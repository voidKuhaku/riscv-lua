local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("fdiv.s")

describe("fdiv.s", function()
    local cpu
    local instructionData

    before_each(function()
        cpu = CPU.new()
        instructionData = {
            opcode = opcode,
            funct3 = funct3,
            funct7 = funct7,
        }
    end)

    it("divides floats", function()
        cpu.fregisters[1] = 6.0
        cpu.fregisters[2] = 2.0
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.same(3.0, cpu.fregisters[1])
    end)
end)
