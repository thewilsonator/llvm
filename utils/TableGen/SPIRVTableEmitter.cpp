//===- SPIRVTableEmitter.cpp - Backend tables for SPIRV ---------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This tablegen backend emits the instruction encoding tables for the SPIRV
// backend.
//
//===----------------------------------------------------------------------===//


#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/Record.h"
#include <vector>
using namespace llvm;

enum class SpecSection {
    MagicNumber    = 1,
    SourceLanguage = 2,
    ExecutionModel = 3,
    AddressModel   = 4,
    MemoryModel    = 5,
    ExecutionMode  = 6,
    StorageClass   = 7,
    Dim            = 8,
    SamplerAddressingMode = 9,
    SamplerFilterMode = 10,
    ImageFormat       = 11,
    ImageChannelOrder = 12,
    ImageChannelDataType = 13,
    ImageOperand      = 14,
    FPFastMathMode    = 15,
    RoundingMode      = 16,
    LinkageType       = 17,
    AccessQualifier   = 18,
    FunctionParameteAttribute = 19,
    Decoration        = 20,
    BuiltIn           = 21,
    SelectionControl  = 22,
    LoopControl       = 23,
    FunctionControl   = 24,
    MemorySemantics   = 25,
    MemoryAccess      = 26,
    Scope             = 27,
    GroupOperation    = 28,
    KernelEnqueueFlags = 29,
    KernelProfilingInfo = 30,
    Capabilities      = 31,
};

struct Operand {
    enum class Tag {
        Invalid,
        ID,
        Imm,
        Enum,
        Bits = 2,
    };
    enum class Type {
            Invalid = 0,
            Any,
            Void,
            // Fundamental types
            Bool,
            Int,
            Float,
            // Specialised Fundamental types
            Int32,
            Float16,
            Float32,
            Sint,
            Uint,
            // Heterogeneous Composite
            Struct,
            Function,
            // Opaque
            Forward,
            Opaque,
            // Image
            Image,
            Sampler,
            SampledImage,
            //Pipes
            Pipe,
            PipeStorage,
            ReserveId,
            // Host
            Event,
            DeviceEvent,
            Queue,
            NamedBarrier,
            InstructionSet,
            Label,
            String,
            DecorationGroup,
            NDRange,
            Bits = 8,
        };
    enum class TypeQual {
        Type,
        Var,
        Const,
        SpecConst,
        Bits = 2,
    };
    enum class TypeExt {
            None = 0,
            Scalar = 0,
            AliasesExist = 1,
            Pointer,
            VecScal,
            Vector,
            Matrix,
            PointerVector,
            Array,
            RuntimeArray,
            StructVecScal2,
            Bits = 4,
        };
    union {
        char enum_imm_type;
        Type type;
    };
    std::string str; // string operands string

};

struct Enum {
    unsigned Op;
    unsigned DependsOn : 31; // capability dependancy
    unsigned isMask : 1;
    SpecSection section;
    std::vector<Operand> FollowedLiterals;
    std::vector<Enum> Capabilities;
    
};

struct InstructionSet {
    short val;
    short version;
};

struct Instruction {
    unsigned Op, Op2, BaseWordCount;
    unsigned ResultIdIndex : 23;
    unsigned BBTerminator : 1;
    unsigned InstClass : 5;
    unsigned VariableLength : 1;
    unsigned ISetVal : 2;
    std::vector<Operand> Operands;
    std::vector<Enum> Capabilities;
    // Sort by Op then Op2
    bool operator< ( const Instruction& rhs)
    {
        if (Op < rhs.Op) return true;
        if (Op > rhs.Op) return false;
        return (Op2 < rhs.Op2);
    }
};

class SPIRVTableEmitter {
    RecordKeeper &Records;
    
public:
    SPIRVTableEmitter(RecordKeeper &R) : Records(R) {}
    
    void run(raw_ostream &OS);
    
    void emitEnums(raw_ostream &OS);
    
    void emitEnumCapability(raw_ostream &OS);
    // Capability table
        // ExecutionModel 1
        // AddressModel 0 or 1
        // MemoryModel 1
        // ExecutionMode 1
        // StorageClass 0 or 1
        // Dim 0 or 1
        // SamplerAddressingMode Kernel
        // SamplerFilterMode Kernel
        // ImageFormat 0 or 1
        // ImageChannelOrder Kernel
        // ImageChannelDataType Kernel
        // ImageOperand 0 or 1
        // FPFastMathMode Kernel
        // RoundingMode Kernel
        // LinkageType Linkage
        // AccessQualifier Kernel
        // FunctionParameteAttribute Kernel
        // Decoration 0 or 1
        // Builtin 0 or 1
        // {Selection,Loop,Function}Control none
        // MemorySemantics 0 or 1
        // MemoryAccess none
        // Scope none
        // GroupOperation Kernel
        // Kernel{EnqueueFlags,ProfilingFlags} Kernel
    // FollowedLiteral table
        // ExecutionMode 1 2 or 3 `ExecutionModel`s
        // Decoration 0 1 or 2
        // LoopControl 0 or 1
        // MemoryAccess 0 or 1
    // StorageClass address space tables
        // Both directins
    // ImageOperand Dimension table
    // isID MemorySemantics & Scope
    
    // Instruction tables: Core, OpenCL & GLSL450
        // BaseInfo table
        // Capability table
        // Operand table
    
    // Instrinsics bidirectional table

};
