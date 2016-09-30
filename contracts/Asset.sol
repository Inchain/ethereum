// pragma solidity ^0.3.6;

import "EToken.sol";

contract Asset is Safe {
    event Transfer(address indexed from, address indexed to, uint value);
    event Approve(address indexed from, address indexed spender, uint value);

    EToken public eToken;
    bytes32 public symbol;

    function init(address _eToken, bytes32 _symbol) noValue() immutable(address(eToken)) returns(bool) {
        EToken ma = EToken(_eToken);
        if (!ma.isCreated(_symbol)) {
            return false;
        }
        eToken = ma;
        symbol = _symbol;
        return true;
    }

    modifier onlyEToken() {
        if (msg.sender == address(eToken)) {
            _
        }
    }

    function totalSupply() constant returns(uint) {
        return eToken.totalSupply(symbol);
    }

    function balanceOf(address _owner) constant returns(uint) {
        return eToken.balanceOf(_owner, symbol);
    }

    function allowance(address _from, address _spender) constant returns(uint) {
        return eToken.allowance(_from, _spender, symbol);
    }

    function transfer(address _to, uint _value) returns(bool) {
        return __transferWithReference(_to, _value, "");
    }

    function transferWithReference(address _to, uint _value, string _reference) returns(bool) {
        return __transferWithReference(_to, _value, _reference);
    }

    function __transferWithReference(address _to, uint _value, string _reference) private noValue() returns(bool) {
        return _isHuman() ?
            eToken.proxyTransferWithReference(_to, _value, symbol, _reference) :
            eToken.transferFromWithReference(msg.sender, _to, _value, symbol, _reference);
    }

    function transferToICAP(bytes32 _icap, uint _value) returns(bool) {
        return __transferToICAPWithReference(_icap, _value, "");
    }

    function transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) returns(bool) {
        return __transferToICAPWithReference(_icap, _value, _reference);
    }

    function __transferToICAPWithReference(bytes32 _icap, uint _value, string _reference) private noValue() returns(bool) {
        return _isHuman() ?
            eToken.proxyTransferToICAPWithReference(_icap, _value, _reference) :
            eToken.transferFromToICAPWithReference(msg.sender, _icap, _value, _reference);
    }
    
    function transferFrom(address _from, address _to, uint _value) returns(bool) {
        return __transferFromWithReference(_from, _to, _value, "");
    }

    function transferFromWithReference(address _from, address _to, uint _value, string _reference) returns(bool) {
        return __transferFromWithReference(_from, _to, _value, _reference);
    }

    function __transferFromWithReference(address _from, address _to, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
        return eToken.proxyTransferFromWithReference(_from, _to, _value, symbol, _reference);
    }

    function transferFromToICAP(address _from, bytes32 _icap, uint _value) returns(bool) {
        return __transferFromToICAPWithReference(_from, _icap, _value, "");
    }

    function transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) returns(bool) {
        return __transferFromToICAPWithReference(_from, _icap, _value, _reference);
    }

    function __transferFromToICAPWithReference(address _from, bytes32 _icap, uint _value, string _reference) private noValue() onlyHuman() returns(bool) {
        return eToken.proxyTransferFromToICAPWithReference(_from, _icap, _value, _reference);
    }

    function approve(address _spender, uint _value) noValue() onlyHuman() returns(bool) {
        return eToken.proxyApprove(_spender, _value, symbol);
    }

    function setCosignerAddress(address _cosigner) noValue() onlyHuman() returns(bool) {
        return eToken.proxySetCosignerAddress(_cosigner, symbol);
    }

    function emitTransfer(address _from, address _to, uint _value) onlyEToken() {
        Transfer(_from, _to, _value);
    }

    function emitApprove(address _from, address _spender, uint _value) onlyEToken() {
        Approve(_from, _spender, _value);
    }

    function sendToOwner() noValue() returns(bool) {
        address owner = eToken.owner(symbol);
        uint balance = this.balance;
        bool success = true;
        if (balance > 0) {
            success = _unsafeSend(owner, balance);
        }
        return eToken.transfer(owner, balanceOf(owner), symbol) && success;
    }
}
