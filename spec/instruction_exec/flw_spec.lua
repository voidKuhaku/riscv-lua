local Memory = require("memory").Memory
local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("flw")

describe("flw", function()
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

    it("loads a float", function()
        local bytes = string.pack("<f", 1.5)
        local word = string.unpack("<I4", bytes)
        memory:writeWord(0x04, word)
        instructionData.rd = 1
        instructionData.rs1 = 0
        instructionData.imm = 4
        local inst = Instruction.new(instructionData)

        inst:exec(cpu, memory)

        assert.are.same(1.5, cpu.fregisters[1])
    end)
end)
