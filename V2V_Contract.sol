// SPDX-License-Identifier: MIT
//pragma solidity >=0.4.22 <0.8.0;
pragma experimental ABIEncoderV2;

contract V2V_contract {
    address public owner;
    
    mapping(address => Requester) private requesters;               // mapping to requesters information
	mapping(address => Provider) private providers;                 // mapping to providers information
	
	address[] private arequesters;                                  // Array of all requesters addresses
	address[] private aproviders;                                   // Array of all providers addresses
    
    mapping (uint => address[]) private aMPrequesters;              // Mapping to requesters in each meeting point
	mapping (uint => address[]) private aMPproviders;               // Mapping to requesters in each meeting point
    
    mapping(address => address[][]) private pereferenceRequesters;  // Mapping to each requester's Preference List
    mapping(address => address[][]) private pereferenceProviders;   // Mapping to each proivder's Preference List

    mapping(address => uint[]) private RfreeMP;                     // Mapping indicating whether a requester is free or matched 
    mapping(address => address[]) private wtomMP;                   // Mapping to the requester that a given provider is matched to
    
	uint mps = 25; // available meeting points

    constructor() public {
        owner = msg.sender;
    }

	///////////////////
	//// REQUESTER ////
	///////////////////

	// Struct for the information of a requester
	struct Requester {
		uint X_R;
        uint Y_R;
        uint v_Rx10;
        uint SoC_R;
        uint Soc_C;
        uint theta_R;
        uint acr_Rx100;
        uint car_id;
        uint zone;  // Meeting Point
	}
	
	// Adding the information of a new requester
    function addNewRequester(
        uint X_R,
        uint Y_R,
        uint v_Rx10,
        uint SoC_R,
        uint Soc_C,
        uint theta_R,
        uint acr_Rx100,
        uint car_id,
        uint zone) public {
        arequesters.push(msg.sender);
        RfreeMP[msg.sender] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
        
		requesters[msg.sender] = Requester({
            X_R: X_R,
            Y_R: Y_R,
            v_Rx10: v_Rx10,
            SoC_R: SoC_R,
            Soc_C: Soc_C,
            theta_R: theta_R,
            acr_Rx100: acr_Rx100,
            car_id: car_id,
            zone: zone
        });
    }

	// Reading the information of a requester
	function getRequester (address addr) 
	            public view 
				returns (uint X_R,
                        uint Y_R,
                        uint v_Rx10,
                        uint SoC_R,
                        uint Soc_C,
                        uint theta_R,
                        uint acr_Rx100,
                        uint car_id,
                        uint zone) {
				Requester storage r = requesters[addr];
				return (r.X_R, r.Y_R, r.v_Rx10, r.SoC_R,r.Soc_C,r.theta_R,r.acr_Rx100,r.car_id,r.zone);
	}

	function getAllRequesters() public view
				returns (address[] memory) {
				return (arequesters);
	}

	// Adding the preference list of a requester	
    function addPereferenceRequester(
                address [][] memory arr, uint [] memory available) public {
            pereferenceRequesters[msg.sender] = arr ;
            for (uint i = 0; i < available.length; i++){
                if (available[i] == 1){
                    aMPrequesters[i].push(msg.sender);
                }
            }
    }

	// Read the preference list of a requester	
    function getPereferenceRequester(address addr)
                public view
                returns (address[][] memory) {
                return pereferenceRequesters[addr];
    }
    
      function getavaiableRequester(uint MP)
                public view
                returns (address[] memory) {
                return aMPrequesters[MP];
    }
	
	
	///////////////////
	///// PROVIDER ////
	///////////////////
	
	// Struct for the information of a provider	
	struct Provider {
		uint X_P;
        uint Y_P;
        uint v_Px10;
        uint tradingPx10;
        uint acr_Px100;
        uint car_id;
        uint zone;  // Meeting Point
	}

	// Adding the information of a new provider	
	function addNewProvider(
				uint X_P,
                uint Y_P,
                uint v_Px10,
                uint tradingPx10,
                uint acr_Px100,
                uint car_id,
                uint zone) public {
			aproviders.push(msg.sender);
            wtomMP[msg.sender] = [address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0)];

			providers[msg.sender] = Provider({
					X_P:X_P,
                    Y_P:Y_P,
                    v_Px10:v_Px10,
                    tradingPx10:tradingPx10,
                    acr_Px100:acr_Px100,
                    car_id:car_id,
                    zone:zone
	    	});
	}
    
	// Reading the information of a provider
	function getProvider(address addr) public view 
				returns (   uint X_P,
                            uint Y_P,
                            uint v_Px10,
                            uint tradingPx10,
                            uint acr_Px100,
                            uint car_id,
                            uint zone ) {
				Provider storage p = providers[addr];
				return (p.X_P, p.Y_P, p.v_Px10, p.tradingPx10,p.acr_Px100,p.car_id, p.zone);
	}

	function getAllProviders() public view
				returns ( address[] memory) {
				return (aproviders);
	}

	// Adding the preference list of a provider	
	function addPereferenceProvider(
        address [][] memory arr, uint [] memory available) public {
        pereferenceProviders[msg.sender] = arr;
        for (uint i = 0; i < available.length; i++){
                if (available[i] == 1){
                    aMPproviders[i].push(msg.sender);
                }
            }
    }
	
	// Reading the preference list of a provider	
    function getPereferenceProvider(address addr)
        public view
        returns (address[][] memory) {
        return pereferenceProviders[addr];
    }
    
    function getavaiableProvider(uint MP)
                public view
                returns (address[] memory) {
                return aMPproviders[MP];
    }
}