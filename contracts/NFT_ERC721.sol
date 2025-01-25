// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


interface ERC721 /* is ERC165 */ {

    // Eventos
    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    //Funciones
    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) external payable;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    function approve(address _approved, uint256 _tokenId) external payable;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

interface ERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface ERC721Metadata /* is ERC721 */ {
    function name() external view returns (string memory _name);
    function symbol() external view returns (string memory _symbol);
}

struct Project {
    string name;
    uint256 co2Amount;
}

contract CreditosClimateCoin is ERC721Metadata, ERC165 {
    string public name = "NFT_ClimateCoin";
    string public symbol = "CCC";
    uint256 lastTokenId = 0;

    mapping(address=>uint256) public balanceOf;
    mapping(uint256=>address) public ownerOf;
    mapping(uint256=>address) public getApproved;
    mapping(address=>mapping(address=>bool)) public isApprovedForAll;

    mapping(uint256=>string) public projectName;
    mapping(uint256=>uint256) public co2Amount;

    //mapping(uint256=>Project) public metadata;

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == type(ERC721).interfaceId || interfaceID == type(ERC165).interfaceId || interfaceID == type(ERC721Metadata).interfaceId;
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(_from == ownerOf[_tokenId]);
        if (ownerOf[_tokenId] == msg.sender || 
            getApproved[_tokenId] == msg.sender || 
            isApprovedForAll[ownerOf[_tokenId]][msg.sender]) {
                ownerOf[_tokenId] = _to;
                balanceOf[_from]--;
                balanceOf[_to]++;
        } else {
            revert("No tienes permiso");
        }
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        if (msg.sender == ownerOf[_tokenId]) {
            getApproved[_tokenId] = _approved;
        }
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        isApprovedForAll[msg.sender][_operator] = _approved;
    }

    function mint(address _to, string calldata _projectName, uint256 _co2Amount) public {
        ownerOf[lastTokenId] = _to;
        balanceOf[_to]++;
        projectName[lastTokenId] = _projectName;
        co2Amount[lastTokenId] = _co2Amount;

        //metadata[lastTokenId] = Project(_projectName, _co2Amount);

        lastTokenId++;
    }

    function burn(uint256 _tokenId, uint256 _co2Amount) public {
        if (_co2Amount > co2Amount[_tokenId]) {
            revert("No se puede quemar tanto del NFT");
        }
        co2Amount[_tokenId] -= _co2Amount;
    }
}