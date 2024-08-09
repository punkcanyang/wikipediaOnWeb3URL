// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Manual is Ownable {
    constructor() Ownable(msg.sender) {}

    function resolveMode() external pure returns (bytes32) {
        return "manual";
    }

    // fallback函数被设计为处理发送到合约地址的数据调用，特别是不匹配任何其他函数签名的调用
    fallback(bytes calldata cdata) external returns (bytes memory) {
        // 检查传入的数据长度是否为0，或者数据的第一个字节是否不等于0x2f（即'/'字符）
        // 如果任一条件满足，则返回一个空的字节序列
        if (cdata.length == 0 || cdata[0] != 0x2f) {
            return bytes("");
        }

        // 如果请求只包含一个'/'字符，返回首页内容
        // 调用indexHTML(1)生成首页的HTML内容，并将其编码为字节序列返回
        if (cdata.length == 1) {
            return bytes(abi.encode(indexHTML(1)));
        }
        // 检查是否为形如'/index/[uint]'的请求
        else if (
            cdata.length >= 6 && ToString.compare(string(cdata[1:6]), "index")
        ) {
            uint page = 1;
            // 如果路径后有更多字符，尝试解析页码
            if (cdata.length >= 8) {
                page = ToString.stringToUint(string(cdata[7:]));
            }
            // 如果解析页码为0，返回"Not found"
            if (page == 0) {
                return abi.encode("Not found");
            }
            // 否则，调用indexHTML(page)获取指定页码的HTML内容，并编码返回
            return abi.encode(indexHTML(page));
        }

        // 如果以上条件均不满足，返回"Not found"
        return abi.encode("Not found");
    }

    // 示例HTML内容生成函数，实际内容应根据具体应用进行设计
    function indexHTML(uint page) internal pure returns (string memory) {
        if (page == 1) {
            return "<html><body><h1>Hello World,Neo!</h1></body></html>";
        } else {
            return
                string(
                    abi.encodePacked(
                        "<html><body><h1>Page ",
                        ToString.uintToString(page),
                        "</h1></body></html>"
                    )
                );
        }
    }
}

// 工具库：用于字符串和整数转换
library ToString {
    // 比较两个字符串是否相等，返回布尔值
    function compare(
        string memory a,
        string memory b
    ) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }

    // 将字符串转换为整数，仅在格式正确时有效
    function stringToUint(string memory s) internal pure returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        for (uint i = 0; i < b.length; i++) {
            uint8 bValue = uint8(b[i]); // 转换 bytes1 到 uint8
            if (bValue >= 48 && bValue <= 57) {
                result = result * 10 + (bValue - 48);
            } else {
                break;
            }
        }
        return result;
    }

    // 将整数转换为字符串
    function uintToString(uint v) internal pure returns (string memory) {
        if (v == 0) {
            return "0";
        }
        uint j = v;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (v != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(v - (v / 10) * 10));
            bstr[k] = bytes1(temp);
            v /= 10;
        }
        return string(bstr);
    }
}
