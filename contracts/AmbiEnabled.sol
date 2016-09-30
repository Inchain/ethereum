// pragma solidity ^0.3.6;

import "Ambi.sol";

contract AmbiEnabled {
    Ambi public ambiC;
    bool public isImmortal;
    bytes32 public nodeName;

    modifier checkAccess(bytes32 _role) {
        if(address(ambiC) != 0x0 && ambiC.hasRelation(nodeName, _role, msg.sender)) {
            _
        }
    }
    
    function getAddress(bytes32 _name) constant returns(address) {
        return ambiC.getNodeAddress(_name);
    }

    function setAmbiAddress(address _ambi, bytes32 _name) returns(bool) {
        if(address(ambiC) != 0x0){
            return false;
        }
        Ambi ambiContract = Ambi(_ambi);
        if(ambiContract.getNodeAddress(_name) != address(this)) {
            if (!ambiContract.addNode(_name, address(this))) {
                return false;
            }
        }
        nodeName = _name;
        ambiC = ambiContract;
        return true;
    }

    function immortality() checkAccess("owner") returns(bool) {
        isImmortal = true;
        return true;
    }

    function remove() checkAccess("owner") returns(bool) {
        if (isImmortal) {
            return false;
        }
        selfdestruct(msg.sender);
        return true;
    }
}