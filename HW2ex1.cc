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
	int curPortVal, curOutVal;
	bool firstPort = true;
	for(it_instPort = curInst->getInstPorts().begin();it_instPort!=curInst->getInstPorts().end(); it_instPort++){
		curPort = it_instPort->second->getPort();
		if(curPort->getDirection()==IN){
			it_instPort->second->getNode()->getProp("Value",curPortVal);
			if(firstPort){
				curOutVal = curPortVal;
				firstPort = false;
			}
			else{
				if(cell_name.find("or") || cell_name.find("nor"))
					curOutVal = curOutVal | curPortVal;
				else if (cell_name.find("and") || cell_name.find("nand"))
					curOutVal = curOutVal & curPortVal;
				else if (cell_name.find("xor") || cell_name.find("xnor"))
					curOutVal = curOutVal ^ curPortVal;				
			}
		}
		else if(curPort->getDirection()==OUT) {
			outInstPort = it_instPort->second;
		}
		if (cell_name.find("xnor")||cell_name.find("not")||cell_name.find("nand")||cell_name.find("nor"))
			curOutVal = !curOutVal;
		outInstPort->setProp("Value",curOutVal);	
	}

outInstPort->getNode()->setProp("Value", curOutVal);
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

	//Add "value" parameter to the all node, initilize it to -1 (not defined)
	map<string, hcmNode*>::iterator it_node;
	map<string, hcmInstPort*>::iterator it_instPort;
	map<string, hcmInstance*>::iterator it_inst;
	set<string>::iterator it_signal;
    int init_node_value = 0;
	bool curInVal,newInVal,curOutVal,newOutVal,curCLK;
	bool inst_visited = false;
	queue<hcmInstance*> gate_que;
	queue<hcmNode*> node_que;
	hcmNode* curNode;
	hcmInstance* curInst;

	for(it_node = flatCell->getNodes().begin(); it_node != flatCell->getNodes().end(); it_node++){
        it_node->second->setProp("Value", init_node_value); // Each node will have signal value attached
    }

	for(it_inst = flatCell->getInstances().begin(); it_inst != flatCell->getInstances().end(); it_inst++){
        it_inst->second->setProp("Visited", inst_visited);// Each instance will have a marker, to prevent doubling in gate queue
    }

	// reading each vector
	while (parser.readVector() == 0) {
		// set the inputs to the values from the input vector.
		for(it_signal=signals.begin();it_signal!=signals.end();it_signal++){
			flatCell->getPort(*it_signal)->owner()->getProp("Value", curInVal);// Get current node signal value
			parser.getSigValue(*it_signal,newInVal);// Get signal value from vector
			parser.getSigValue("CLK",curCLK);//Get CLK signal value, to simplify next steps
			if(curInVal!=newInVal){ // WARNING: all values init. to 0, if we get a first vector 0..0 there wont be any update
				flatCell->getPort(*it_signal)->owner()->setProp("Value", newInVal);// Update the node signal value
				node_que.push(flatCell->getPort(*it_signal)->owner());// Push the current node in the node queue
			}
		}
		// simulate the vector 
		while(!node_que.empty()){//Event_Processor
			curNode = node_que.front();
			node_que.pop();
			for(it_instPort=curNode->getInstPorts().begin();it_instPort!=curNode->getInstPorts().end();it_instPort++){
				if (it_instPort->second->getPort()->getDirection() == IN){// Check only nodes connected to IN ports
					if(it_instPort->second->getInst()->getProp("Visited", inst_visited)==false){
						gate_que.push(it_instPort->second->getInst());// Push the current gate in the node queue
						it_instPort->second->getInst()->setProp("Visited", true);
					}
				}
			}
			//WARNING: Im assuming that every gate has only one OUT port (in a flat model).
			while(!gate_que.empty()){ //Gate_Processor
				curInst = gate_que.front();
				gate_que.pop();
				curInst->setProp("Visited", false);
				for(it_instPort=curInst->getInstPorts().begin();it_instPort!=curInst->getInstPorts().end();it_instPort++){
					if (it_instPort->second->getPort()->getDirection() == OUT){// Check only nodes connected to OUT port
						it_instPort->second->getPort()->owner()->getProp("Value",curOutVal);
						evaluate_gate(curInst);
						it_instPort->second->getPort()->owner()->getProp("Value",newOutVal);
						if(curOutVal!=newOutVal){
							node_que.push(it_instPort->second->getPort()->owner());// Out value of a gate changed, hence pushing node to node queue
						}
					}
				}
			}
		}
		// go over all values and write them to the vcd.
		
		vcd.changeTime(time++);
	}

	//-----------------------------------------------------------------------------------------//
}	
