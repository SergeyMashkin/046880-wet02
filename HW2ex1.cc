#include <errno.h>
#include <signal.h>
#include <sstream>
#include <fstream>
#include <algorithm>
#include <queue>
#include "hcm.h"
#include "flat.h"
#include "hcmvcd.h"
#include "hcmsigvec.h"

using namespace std;

//globals:
bool verbose = false;

/** @fn void evaluate_gate(hcmInstance *curInst)
 * @brief Evaluate gate's logic and update its output
 * @param curInst - pointer to the hcmInstance 
 * @return none
 */
void evaluate_gate(hcmInstance *curInst){
	string cell_name = curInst->masterCell()->getName();
	map<string, hcmInstPort*>::iterator it_instPort;
	hcmInstPort* outInstPort;
	hcmPort* curPort;
	bool curPortVal, curOutVal;
	bool firstPort = true;
	for(it_instPort = curInst->getInstPorts().begin();it_instPort!=curInst->getInstPorts().end(); it_instPort++){
		// if instance is i6 , print all of its pots values

		curPort = it_instPort->second->getPort();
		if(curPort->getDirection()==IN){
			it_instPort->second->getNode()->getProp("Value",curPortVal);
			cout << "Eval_Gate : IN node name: " << it_instPort->second->getNode()->getName() << " value: " << curPortVal << endl;
			if(firstPort){
				curOutVal = curPortVal;
				firstPort = false;
			}
			else{
				if ((cell_name.find("xor") != std::string::npos) || (cell_name.find("xnor") != std::string::npos)) 
					curOutVal = curOutVal ^ curPortVal;
				else if ((cell_name.find("or") != std::string::npos) || (cell_name.find("nor") != std::string::npos))
					curOutVal = curOutVal | curPortVal;
				else if ((cell_name.find("and") != std::string::npos) || (cell_name.find("nand") != std::string::npos)) 
					curOutVal = curOutVal & curPortVal;
			}
		}
		else if(curPort->getDirection()==OUT) {
			outInstPort = it_instPort->second;
		}

		// check here if need to add node to queue?
	}
	// if cell_name is not/xnor/nand/nor - invert the output
	if (cell_name.find("not")!= std::string::npos || cell_name.find("nor")!= std::string::npos 
					|| cell_name.find("nand")!= std::string::npos  || cell_name.find("xnor")!= std::string::npos)
		curOutVal = !curOutVal;
	// throw error if curOutVal is not defined 0 or 1

	// stop the code
	cout << "setting value for " << outInstPort->getNode()->getName() << " to " << curOutVal << endl;	
	outInstPort->getNode()->setProp("Value", curOutVal);
}

bool isLooping(hcmInstance *inst, hcmInstance *inst2) {
	for (auto it: inst->getInstPorts()) {
		if (it.second->getPort()->getDirection() == OUT) {
			for (auto it2: it.second->getNode()->getInstPorts()) {
				if (it2.second->getPort()->getDirection() == IN) {
					if (it2.second->getInst() == inst2) {
						cout << "looping: " << inst->getName() << " " << inst2->getName() << endl;
						return true;
					}
				}
			}
		}
	}
	return false;
}

// setRank - recursive functions that sets the rank of instance, and continuees to instances connected to it's output.
// function assumes instances is not only VSS VDD.
void setRank(hcmInstance *inst, int rank) {
	inst->setProp("rank", rank);
	for (auto it : inst->getInstPorts()) {
		if (it.second->getPort()->getDirection() == OUT) {
			for (auto it2 : it.second->getNode()->getInstPorts()) {
				if (it2.second->getPort()->getDirection() == IN) {
					// to prevent looping
					int currRank=-1;
					it2.second->getInst()->getProp("rank", currRank);
					// only go in if rank is lower than current rank
					if (currRank <= rank) {
						if (isLooping(it2.second->getInst(), inst)){
							cout << "Detected loop from inst-Getname:" << inst->getName() << " or from inst->masterCell()->getName()" << inst->masterCell()->getName() << endl;
							cout << "looping gate: " << it2.second->getInst()->getName() << endl;
							// if it2.second->getInst()->getName() ends with "nor_0" or "nor_2" do not go in
							if (it2.second->getInst()->getName().find("nor_0") != std::string::npos || it2.second->getInst()->getName().find("nor_2") != std::string::npos) {
							    continue;
							}
					}
						setRank(it2.second->getInst(), rank + 1);
					}
				}
			}
		}
	}
}

int main(int argc, char **argv) {
	int argIdx = 1;
	int anyErr = 0;
	unsigned int i;
	vector<string> vlgFiles;
	
	if (argc < 5) {
		anyErr++;
	} 
	else {
		if (!strcmp(argv[argIdx], "-v")) {
			argIdx++;
			verbose = true;
		}
		for (;argIdx < argc; argIdx++) {
			vlgFiles.push_back(argv[argIdx]);
		}
		
		if (vlgFiles.size() < 2) {
			cerr << "-E- At least top-level and single verilog file required for spec model" << endl;
			anyErr++;
		}
	}

	if (anyErr) {
		cerr << "Usage: " << argv[0] << "  [-v] top-cell signal_file.sig.txt vector_file.vec.txt file1.v [file2.v] ... \n";
		exit(1);
	}
 
	set< string> globalNodes;
	globalNodes.insert("VDD");
	globalNodes.insert("VSS");
	
	hcmDesign* design = new hcmDesign("design");
	string cellName = vlgFiles[0];
	for (i = 3; i < vlgFiles.size(); i++) {
		printf("-I- Parsing verilog %s ...\n", vlgFiles[i].c_str());
		if (!design->parseStructuralVerilog(vlgFiles[i].c_str())) {
			cerr << "-E- Could not parse: " << vlgFiles[i] << " aborting." << endl;
			exit(1);
		}
	}

	hcmCell *topCell = design->getCell(cellName);
	if (!topCell) {
		printf("-E- could not find cell %s\n", cellName.c_str());
		exit(1);
	}
	
	hcmCell *flatCell = hcmFlatten(cellName + string("_flat"), topCell, globalNodes);
	cout << "-I- Top cell flattened" << endl;

	string signalTextFile = vlgFiles[1];
	string vectorTextFile = vlgFiles[2];

	
	// Genarate the vcd file
	//-----------------------------------------------------------------------------------------//
	// If you need to debug internal nodes, set debug_mode to true in order to see in 
	// the vcd file and waves the internal nodes.
	// NOTICE !!!
	// you need to submit your work with debug_mode = false
	// vcdFormatter vcd(cellName + ".vcd", flatCell, globalNodes, true);  <--- for debug only!
	//-----------------------------------------------------------------------------------------//
	vcdFormatter vcd(cellName + ".vcd", flatCell, globalNodes);
	if(!vcd.good()) {
		printf("-E- vcd initialization error.\n");
		exit(1);
	}

	// initiate the time variable "time" to 1 
	int time = 1;
	hcmSigVec parser(signalTextFile, vectorTextFile, verbose);
	set<string> signals;
	parser.getSignals(signals);

	//-----------------------------------------------------------------------------------------//
	//enter your code below
	list<const hcmInstance*> parent_l;
	//Add "value" parameter to the all node, initilize it to -1 (not defined)
	map<string, hcmNode*>::iterator it_node;
	map<string, hcmInstPort*>::iterator it_instPort;
	map<string, hcmInstance*>::iterator it_inst;
	set<string>::iterator it_signal;
    bool init_node_value = 0;
	bool curInVal = 0;
	bool newInVal = 0;
	bool curOutVal = 0; 
	bool newOutVal = 0;
	bool curCLK = 0;
	bool in_gates_que = false;
	bool first_node_run = true;
	queue<hcmInstance*> gate_que;
	queue<hcmNode*> node_que;
	hcmNode* curNode;
	hcmInstance* curInst;
	// initialize 
	for(it_node = flatCell->getNodes().begin(); it_node != flatCell->getNodes().end(); it_node++){
        it_node->second->setProp("Value", init_node_value); // Each node will have signal value attached
    }
	for(it_inst = flatCell->getInstances().begin(); it_inst != flatCell->getInstances().end(); it_inst++){
        it_inst->second->setProp("InQue", in_gates_que);// Each instance will have a marker, to prevent doubling in gate queue
    }
	vector<pair<int, string>> maxRankVector;
	for (auto it: flatCell->getInstances()){
		it.second->setProp("rank", -1);
	}
	for (auto it: flatCell->getPorts()) {
		cout << "port: " << it->getName() << " direction: " << it->getDirection() << endl;
		if (it->getDirection() == IN ) {
		// skip VSS / VDD Nodes
			if (it->owner()->getName() != "VDD" && it->owner()->getName() != "VSS") {
				for (auto it2: it->owner()->getInstPorts()) {
					int rank = -1;
					it2.second->getInst()->getProp("rank", rank);
					cout << "Node: " << it2.first << " Rank: " << rank << endl;
					if (rank == -1) {
						setRank(it2.second->getInst(), 0);
					}
				}
			}
		}
	}
	cout << "Starting max rank sorting loop" << endl;
	// insert all instances to maxRankVector, order by increasing rank, if rank equal- order by name
	for (auto it: flatCell->getInstances()) {
		cout << "MaxRank insert loop: instance: " << it.second->getName() << endl;
		int rank = -1;
		it.second->getProp("rank", rank);
		cout << "Rank: " << rank << endl;
		// skip VSS / VDD Nodes
		if (rank == -1) {
			cout << "Skipping instance: " << it.second->getName() << " with rank -1" << endl;
			continue;
		}
		// insert first instance to vector
		if (maxRankVector.empty()) {
			cout << "inserting first instance: " << it.second->getName() << " with rank: " << rank << endl;
			maxRankVector.push_back(make_pair(rank, it.second->getName()));
			continue;
		}
		// insert by order
		cout << "entering insert loop, size of MaxRankVector = " << maxRankVector.size() << endl;
		for (auto it2 = maxRankVector.begin(); true; it2++) {
			//cout << "comparing instance: " << it.first << " with rank: " << rank << " to instance: " << it2->second << " with rank: " << it2->first << endl;
			if (it2 == maxRankVector.end()) {
				maxRankVector.push_back(make_pair(rank, it.second->getName()));
				break;
			}
			if (it2->first > rank) {
				maxRankVector.insert(it2, make_pair(rank, it.second->getName()));
				break;
			} else if (it2->first == rank) {
				if (it2->second > it.second->getName()) {
					maxRankVector.insert(it2, make_pair(rank, it.second->getName()));
					break;
				}
			}
				// if reached end - insert

		}
	}
	// print out all instances in maxRankVector and their rank
	for (auto it: maxRankVector) {
		cout << "instance: " << it.second << " rank: " << it.first << endl;
	}
	//exit(1);
	cout << "entering eval_gate" << endl;
	//evaluate gates in order of maxRankVector
	for (auto it: maxRankVector) {
		it_inst = flatCell->getInstances().find(it.second);
		evaluate_gate(it_inst->second);
		// if its a "ff/nor[3]" gate - make sure we got 0 value on output
	}
	// reading each vector
	cout << "entering main loop" << endl;
	while (parser.readVector() == 0) {
		cout << "====================" << "time: " << time << "====================" << endl;
		// if (time == 2) {
		//  	exit(1);
		// }
		// set the inputs to the values from the input vector.
		for(it_signal=signals.begin();it_signal!=signals.end();it_signal++){
			flatCell->getPort(*it_signal)->owner()->getProp("Value", curInVal);// Get current node signal value
			parser.getSigValue(*it_signal,newInVal);// Get signal value from vector
			parser.getSigValue("CLK",curCLK);//Get CLK signal value, to simplify next steps
			if(curInVal!=newInVal){ // WARNING: all values init. to 0, if we get a first vector 0..0 there wont be any update
				cout << "Pushing signal:" << *it_signal << " to queue" << endl;
				flatCell->getPort(*it_signal)->owner()->setProp("Value", newInVal);// Update the node signal value
				node_que.push(flatCell->getPort(*it_signal)->owner());// Push the current node in the node queue
			}
		}
		// update data on FFs out nodes:

		// simulate the vector 
		while(!node_que.empty()){//Event_Processor
			curNode = node_que.front();
			node_que.pop();
			cout << "current node_que: " << node_que.size() << endl;
			// print node's inst ports:
			if (first_node_run) {
				for(it_instPort=curNode->getInstPorts().begin();it_instPort!=curNode->getInstPorts().end();it_instPort++){
					if (it_instPort->second->getPort()->getDirection() == IN){// Check only nodes connected to IN ports
						it_instPort->second->getInst()->getProp("InQue", in_gates_que);
						if (in_gates_que==false) {
							gate_que.push(it_instPort->second->getInst());// Push the current gate in the node queue
							it_instPort->second->getInst()->setProp("InQue", true);
						}
					}
				}
			}
			// //WARNING: Im assuming that every gate has only one OUT port (in a flat model).
			while(!gate_que.empty()){ //Gate_Processor
				cout << "in gate que loop with num of gates: " << gate_que.size() << endl;
				curInst = gate_que.front();
				gate_que.pop();
				curInst->setProp("InQue", false);
				for(it_instPort=curInst->getInstPorts().begin();it_instPort!=curInst->getInstPorts().end();it_instPort++){
					if (it_instPort->second->getPort()->getDirection() == OUT){// Check only nodes connected to OUT port
						cout << "Checking gate:" << curInst->getName() << " port:" << it_instPort->first << endl;
						it_instPort->second->getNode()->getProp("Value",curOutVal);
						if (curOutVal != 0 && curOutVal != 1) {
							cout << "ERROR: curOutVal is not 0 or 1, value " << curOutVal << endl;
							exit(1);
						}
						evaluate_gate(curInst);
						it_instPort->second->getNode()->getProp("Value",newOutVal);
						if (newOutVal != 0 && newOutVal != 1) {
							cout << "ERROR: curOutVal is not 0 or 1, value " << curOutVal << endl;
							exit(1);
						}
						cout << "curOutVal: " << curOutVal << " newOutVal: " << newOutVal << endl;
						if(curOutVal!=newOutVal){
							cout << "Out val changed for gate:" << curInst->getName() << endl;
							it_instPort->second->getPort()->owner()->setProp("Value", newOutVal); // update value for out node
							for (auto it: it_instPort->second->getNode()->getInstPorts()) { // update values of all nodes (inside of gates) that are connected to out node
								if (it.second->getPort()->getDirection() == IN) {
									cout << "updating value IN node:" << it.second->getPort()->owner()->getName() << endl;
									it.second->getPort()->owner()->setProp("Value", newOutVal);
								}
							}
							cout << "pushing node: " << it_instPort->second->getPort()->owner()->getName() << endl;
							node_que.push(it_instPort->second->getNode());// Out value of a gate changed, hence pushing node to node queue
						}
					}
				}
				
			}
		}
		// go over all values and write them to the vcd.
		for (it_node = flatCell->getNodes().begin(); it_node != flatCell->getNodes().end(); it_node++) {
			if (it_node->second->getName() == "VDD" || it_node->second->getName() == "VSS") {
				continue;
			}
			else {
				bool val;
				it_node->second->getProp("Value", val);
				hcmNodeCtx *Ctx = new hcmNodeCtx(parent_l, it_node->second);
				vcd.changeValue(Ctx, val);
			}
		}
		
		vcd.changeTime(time++);
	}

	//-----------------------------------------------------------------------------------------//
}	
