local Memory = require("memory").Memory
local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("fsw")

describe("fsw", function()
    local memory
    local cpu
    local instructionData

    before_each(function()
        memory = Memory.new(0x100)
        cpu = CPU.new()
        instructionData = {
            opcode = opcode,
            funct3 = funct3,
            funct7 = funct7,
        }
    end)

    it("stores a float", function()
        cpu.fregisters[1] = 2.25
        instructionData.rs2 = 1
        instructionData.rs1 = 0
        instructionData.imm = 8
        local inst = Instruction.new(instructionData)

        inst:exec(cpu, memory)

        local word = memory:readWord(8)
        local bytes = string.pack("<I4", word)
        local val = string.unpack("<f", bytes)
        assert.are.same(2.25, val)
    end)
end)
