# **Foundry Setup and Usage**

### **1. Install Foundry**

```bash
curl -L <https://foundry.paradigm.xyz> | bash
```

*Command to install Foundry.*

### **2. Verify Installation**

```bash
foundry --version
```

*Command to verify if Foundry is properly installed.*

### **3. Initialize Foundry Project**

```bash
forge init
```

*Command to initialize a new Foundry project.*

### **4. Compile Contract**

```bash
forge build
```

*Command to compile the smart contract.*

### **5. Run Tests**

```bash
forge test
```

*Command to run the tests.*

### **6. Run Tests with Detailed Output**

```bash
forge test -v
```

*Verbosity Levels:*

- `v` - Basic logs
- `vv` - Detailed logs
- `vvv` - Execution trace for failing tests
- `vvvv` - Execution trace for all tests
- `vvvvv` - Maximum detail

### **7. Run Specific Test File**

```bash
forge test --match-path test/<testFile>.t.sol
```

*Command to run tests in a specific file.*

### **8. Run Tests with Specified Gas Limit**

```bash
forge test --gas-limit <limit>
```

*Command to set a specific gas limit for the tests.*

---

# **VM Commands**

### **1. Warp**

- **Purpose:** Set the block timestamp to a future value.
- **Usage Example:**

    ```solidity
    vm.warp(uint timestamp);
    ```

### **2. Roll**

- **Purpose:** Set the block number to a specific value.
- **Usage Example:**

    ```solidity
    vm.roll(uint blockNumber);
    ```

### **3. Skip**

- **Purpose:** Increment the current timestamp by a specified number of seconds.
- **Usage Example:**

    ```solidity
    vm.skip(uint seconds);
    ```

### **4. Rewind**

- **Purpose:** Decrement the current timestamp by a specified number of seconds.
- **Usage Example:**

    ```solidity
    vm.rewind(uint seconds);
    ```

---

# **Test Cases**

### **1. Bid Function Fails Before Start Time**

```solidity
function test_bidFailsBeforeStartTime() public {
    uint startAt = block.timestamp + 1 days; // Initialize startAt
    vm.warp(startAt - 1); // Warp to just before the auction starts
    vm.expectRevert("Cannot bid before auction starts");
    auction.bid();
}
```

*Test case to ensure bids fail before the auction starts.*

### **2. Bid Function Succeeds After Start Time**

```solidity
function test_bidSucceedsAfterStartTime() public {
    uint startAt = block.timestamp + 1 days; // Initialize startAt
    vm.warp(startAt + 1 days); // Warp time to startAt + 1 day
    auction.bid();
    // Check if bid was successful
}
```

*Test case to ensure bids succeed after the auction starts.*

### **3. Bid Function Fails After Auction Ended**

```solidity
function test_bidFailsAfterEndTime() public {
    uint startAt = block.timestamp + 1 days; // Initialize startAt
    uint endAt = startAt + 1 days; // Initialize endAt
    vm.warp(endAt + 1 seconds); // Warp time to just after the auction ends
    vm.expectRevert("Cannot bid after auction ends");
    auction.bid();
}
```

*Test case to ensure bids fail after the auction ends.*

### **4. Skip and Rewind Example**

```solidity
function test_skipAndRewind() public {
    uint initialTimestamp = block.timestamp;
    vm.skip(100);
    assertEq(block.timestamp, initialTimestamp + 100);

    vm.rewind(10);
    assertEq(block.timestamp, initialTimestamp + 90);
}
```

*Test case demonstrating the use of skip and rewind.*

### **5. Set Block Number**

```solidity
function test_setBlockNumber() public {
    uint initialBlockNumber = block.number;
    vm.roll(999);
    assertEq(block.number, 999);
}
```

*Test case to set and verify a specific block number.*

---

# **Execution Commands**

### **1. Run Tests**

```bash
forge test --match-path test/time.t.sol
```

*Command to run tests from a specific file.*

---

# **Command Explanations**

### **1. `deal(address, uint)`**

- **Purpose:** Sets the Ether balance of the specified `address` to the given `uint` value.
- **Example:**

    ```solidity
    deal(address(1), 100);
    assertEq(address(1).balance, 100);
    ```

- **Combined Usage with `prank`:**

    ```solidity
    deal(address(1), 123);
    vm.prank(address(1));
    _send(123);
    ```

### **2. `hoax(address, uint)`**

- **Purpose:** Combines `deal` with `prank`. It sets the Ether balance of the specified `address` to the given `uint` value and makes the next transaction appear as if it came from that `address`.
- **Example:**

    ```solidity
    hoax(address(1), 144);
    _send(144);
    ```

### **3. `vm.prank(address)`**

- **Purpose:** Simulates the next transaction as if it is sent by the specified `address`.
- **Example:**

    ```solidity
    vm.prank(address(1));
    _send(123);
    ```

---

# **Detailed Notes on Transaction Signing in Solidity**

## **Overview**

This document explains the process of signing and verifying a transaction in Solidity, using a provided code example. The code demonstrates how to generate a digital signature and validate it against the original message.

## **Code Breakdown**

### **1. Private Key to Public Key Conversion**

```solidity
uint256 privateKey = 123;
address publicKey = vm.addr(privateKey);
```

- **Private Key**: A confidential numerical value used for signing messages. In this example, a simplified value `123` is used.
- **Public Key**: Generated from the private key using `vm.addr(privateKey)`. This address represents the signer and is used to verify signatures.

### **2. Hashing the Message**

```solidity
bytes32 messageHash = keccak256(abi.encodePacked("Secret message hi what are you doing?"));
```

- **Message**: `"Secret message hi what are you doing?"` is the data that will be signed.
- **Hashing**: `keccak256` generates a unique `bytes32` hash of the message. `abi.encodePacked` is used to encode the message into bytes before hashing.

### **3. Signing the Message**

```solidity
(uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
```

- **Signing**: The `vm.sign` function uses the private key and the message hash to produce a digital signature composed of:
    - `v`: Recovery id, part of the ECDSA signature.
    - `r` and `s`: Signature parts used to validate the signature.

### **4. Recovering the Signer’s Address**

```solidity
address signer = ecrecover(messageHash, v, r, s);
```

- **ecrecover**: This function recovers the Ethereum address that signed the message based on the `messageHash` and signature components (`v`, `r`, `s`). The recovered address should match the public key if the signature is valid.

### **5. Verification of the Signature**

```solidity
assertEq(signer, publicKey);
```

- **Verification**: Asserts that the recovered address from the signature matches the expected public key, confirming the validity of the signature for the given message hash.

### **6. Testing with an Invalid Message**

```solidity
bytes32 invalidMessageHash = keccak256(abi.encodePacked("invalid message"));
signer = ecrecover(invalidMessageHash, v, r, s);
assertTrue(signer != publicKey);
```

- **Invalid Message Hash**: Produces a new message hash from a different message `"invalid message"`.
- **Recovery Attempt**: Tries to recover the address using the signature components and the new hash.
- **Assertion**: Ensures the recovered address does not match the original public key, validating that the signature is not valid for the altered message.

---

# **Notes on Running a Mainnet Test Using Foundry**

## **Overview**

- This guide demonstrates how to run a mainnet test using the Foundry framework.
- The example involves depositing Ether (ETH) into a Wrapped Ether (WETH) contract deployed on the Ethereum mainnet and logging the balance before and after the deposit.

## **Key Concepts**

1. **Mainnet Fork Testing:**

    - **Mainnet Forking:**
        - A mainnet fork is a local simulation of the Ethereum mainnet, containing the entire state of the blockchain up to a specific block. It allows developers to interact with real contracts in a controlled environment without using real ETH.
    - **Simulated ETH:**
        - In the forked environment, transactions are simulated, so no actual ETH is transferred. The testing framework allows you to mint ETH to accounts within this simulated environment, enabling testing without spending real money.

## **Steps in the Process**

1. **Define the WETH

**Interface**

- **Purpose:**
    - The `IWETH` interface defines the contract methods for interacting with the Wrapped Ether (WETH) contract. This example provides a minimal interface with a focus on the `deposit` method and `balanceOf` method.

- **Code:**

    ```solidity
    interface IWETH {
        function deposit() external payable;
        function balanceOf(address account) external view returns (uint256);
    }
    ```

2. **Setup**

    - **Mainnet Fork Provider:**
        - You need a provider URL for the mainnet fork. Services like Alchemy or Infura offer this feature.
    - **Example:**
    
    ```bash
    forge test --fork-url <mainnet-fork-url>
    ```

3. **Test Script**

    - **Setup WETH Contract Instance:**
        - Instantiate the WETH contract using the interface and the contract address from the mainnet fork.

4. **Compile the Contract**

    - **Command:**
    
    ```bash
    forge build
    ```

5. **Test Against Mainnet Fork**

    - **Command:**
    
    ```bash
    forge test --fork-url <mainnet-fork-url> --match-path test/weth.t.sol
    ```

6. **Test Results**

    - **Output:**
        - Check the results of the test to verify that the deposit method behaves as expected in the forked mainnet environment.

---

# **Fuzzing with Foundry**

## **Purpose**

Fuzzing is a testing technique that involves feeding random or unexpected inputs to your code to uncover bugs or vulnerabilities.

### **`assume` Function**

- **Purpose:** Skip the test if certain conditions are not met.
- **Usage:**
    
    ```solidity
    B.assume(X > 0);
    ```

### **`bound` Function**

- **Purpose:** Limit the input value within a specified range.
- **Usage:**
    
    ```solidity
    X = bound(X, 1, 10);
    ```

### **Stats in Fuzz Testing**

- **Runs:** Number of random test cases executed.
- **Mu (Mean):** Average gas usage across all tests.
- **Tilde (~):** Median gas usage.

---

# **Invariant Testing in Foundry: A Detailed Guide**

## **Overview**

Invariant testing ensures that certain conditions or properties hold true across a range of function calls.

### **Example: Setting Up an Invariant Test**

**Contract Code:**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract InvariantPractice {
    bool public flag;

    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}

    function func_5() external {
        flag = true;
    }
}
```

**Test Contract Code:**

```solidity
import {Test, console} from "forge-std/Test.sol";

contract InvariantPracticeTest is Test {
    InvariantPractice private target;

    function setUp() public {
        target = new InvariantPractice();
    }

    function invariant_flagIsAlwaysFalse() public view {
        assertEq(target.flag(), false);
    }
}
```

- **Contract Code:**
    - Defines a `flag` that can be changed by calling `func_5`.
- **Test Contract Code:**
    - Ensures that `flag` remains `false` after any function call.

### **Running and Analyzing the Test**

- **Execution:** Foundry randomly calls functions and checks if the invariant condition holds.
- **Result:** If the invariant is violated, Foundry will report it.

### **Conclusion**

Invariant testing ensures that crucial properties of your contract are maintained across different scenarios.

---

# **Notes on Using FFI in Foundry with Example Code**

**Example Contract for FFI:**

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

contract FFITest is Test {
    function testFFI() public {
        string[] memory cmds = new string[](2);
        cmds[0] = "cat";
        cmds[1] = "ffi.test.txt";
        bytes memory res = vm.ffi(cmds);
        console.log(string(res));
    }
}
```

**Steps to Run the Test:**

1. **Prepare the Environment:**
    - Ensure `ffi.test.txt` is in the correct directory.

2. **Run the Test:**

    ```bash
    forge test --match-path test/FFITest.sol --ffi --vvv
    ```

3. **Expected Output:**
    - Content of `ffi.test.txt` should be printed.

**Summary:**

- Demonstrates using FFI in Foundry to execute system commands within a Solidity test.

## Contact

For further inquiries or feedback, you can reach out via:

- **Email:** [abu.bakar.zia146@proton.me](mailto:abu.bakar.zia146@proton.me)
