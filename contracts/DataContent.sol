// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {TablelandController} from "@tableland/evm/contracts/TablelandController.sol";
import {TablelandPolicy} from "@tableland/evm/contracts/TablelandPolicy.sol";
import {TablelandDeployments} from "@tableland/evm/contracts/utils/TablelandDeployments.sol";
import {SQLHelpers} from "@tableland/evm/contracts/utils/SQLHelpers.sol";
import {ERC721Holder} from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

// DataContent template for contract owned and controlled tables
contract DataContent is TablelandController, ERC721Holder {
    uint256 private tableId; // Unique table ID
    string private constant _TABLE_PREFIX = "DataContent"; // Custom table prefix

    // Constructor that creates a table, sets the controller, and inserts data
    constructor() {
        // Create a table
        tableId = TablelandDeployments.get().create(
            address(this),
            SQLHelpers.toCreateFromSchema(
                "id integer primary key,"
                "input text,output text,processHash text,format text",
                _TABLE_PREFIX
            )
        );
        // Set the ACL controller to enable writes to others besides the table owner
        TablelandDeployments.get().setController(
            address(this), // Table owner, i.e., this contract
            tableId,
            address(this) // Set the controller address—also this contract
        );
    }

    // Sample getter to retrieve the table name
    function tableName() external view returns (string memory) {
        return SQLHelpers.toNameFromId(_TABLE_PREFIX, tableId);
    }

    // Insert a row into the table from an external call (`id` will autoincrement)
    function insertInput(string memory input) external {
        TablelandDeployments.get().mutate(
            address(this),
            tableId,
            SQLHelpers.toInsert(
                _TABLE_PREFIX,
                tableId,
                "input",
                SQLHelpers.quote(input) // Wrap strings in single quotes with the `quote` method
            )
        );
    }

    // Update a row in the table from an external call (set `input` at any `id`)
    function updateInput(uint64 id, string memory input) external {
        string memory setters = string.concat("input=", SQLHelpers.quote(input));
        string memory filters = string.concat("id=", Strings.toString(id));
        // Mutate a row at `id` with a new `input`
        TablelandDeployments.get().mutate(
            address(this),
            tableId,
            SQLHelpers.toUpdate(_TABLE_PREFIX, tableId, setters, filters)
        );
    }

    // Delete a row in the table from an external call (delete at any `id`)
    function deleteInput(uint64 id) external {
        string memory filters = string.concat("id=", Strings.toString(id));
        // Mutate by deleting the row at `id`
        TablelandDeployments.get().mutate(
            address(this),
            tableId,
            SQLHelpers.toDelete(_TABLE_PREFIX, tableId, filters)
        );
    }

    // Insert a row into the table from an external call (`id` will autoincrement)
    function insertOutput(string memory output) external {
        TablelandDeployments.get().mutate(
            address(this),
            tableId,
            SQLHelpers.toInsert(
                _TABLE_PREFIX,
                tableId,
                "output",
                SQLHelpers.quote(output) // Wrap strings in single quotes with the `quote` method
            )
        );
    }

    // Update a row in the table from an external call (set `output` at any `id`)
    function updateOutput(uint64 id, string memory output) external {
        string memory setters = string.concat("output=", SQLHelpers.quote(output));
        string memory filters = string.concat("id=", Strings.toString(id));
        // Mutate a row at `id` with a new `output`
        TablelandDeployments.get().mutate(
            address(this),
            tableId,
            SQLHelpers.toUpdate(_TABLE_PREFIX, tableId, setters, filters)
        );
    }

    // Delete a row in the table from an external call (delete at any `id`)
    function deleteOutput(uint64 id) external {
        string memory filters = string.concat("id=", Strings.toString(id));
        // Mutate by deleting the row at `id`
        TablelandDeployments.get().mutate(
            address(this),
            tableId,
            SQLHelpers.toDelete(_TABLE_PREFIX, tableId, filters)
        );
    }

    // Dynamic ACL controller policy that allows any inserts and updates
    function getPolicy(
        address,
        uint256
    ) public payable override returns (TablelandPolicy memory) {
        // Restrict updates to a single column, e.g., `input`
        string[] memory updatableColumns = new string[](1);
        updatableColumns[0] = "input";
        // Return the policy
        return
            TablelandPolicy({
                allowInsert: true,
                allowUpdate: true,
                allowDelete: false,
                whereClause: "", // Apply WHERE conditions
                withCheck: "", // Apply CHECK conditions
                updatableColumns: updatableColumns
            });
    }
}
