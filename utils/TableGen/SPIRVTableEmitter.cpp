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
#include <algorithm>
#include <array>
#include <vector>
using namespace llvm;
namespace {
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
        Type,       // Id is a type
        Var,        // a variable
        Const,      // a compile time constant
        SpecConst,  // a specialisation constant
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
        char TagQualExt;
        struct {
        char _Tag  : 2;
        char _Qual : 2;
        char _Ext  : 4;
        };
    };
    Tag      tag()       { return static_cast<Tag>(_Tag); }
    TypeQual qualifier() { return static_cast<TypeQual>(_Qual); }
    TypeExt  ext()       { return static_cast<TypeExt>(_Ext); }
        
    char TypeSpecSection;
    
    Type type() {
        assert(tag() == Tag::ID);
        return static_cast<Type>(TypeSpecSection);
    }
    SpecSection specsection() {
        assert(tag() == Tag::Enum);
        return static_cast<SpecSection>(TypeSpecSection);
    }
    StringRef name;
    StringRef str; // string operands string

};

struct Enum {
    unsigned Op;
    unsigned DependsOn : 30; // capability dependancy
    unsigned isMask : 1;
    unsigned isID : 1;
    SpecSection section;
    std::vector<Operand> FollowedLiterals;
    // A given enum only ever has 3 leaf capabilities.
    std::array<unsigned, 3> Capabilities;
    std::array<unsigned, 2> AddressSpaces;
    StringRef name;
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
    std::vector<Operand*> Operands;
    std::vector<Enum*> Capabilities;
    std::string name;
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
    std::array<std::vector<Enum>,32> SPIRVEnums;
    
    // One for each instruction set. Currently Core & OpenCL.
    // TODO: add GLSL450.
    std::array<std::vector<Instruction>,2> SPIRVInstructions;
public:
    SPIRVTableEmitter(RecordKeeper &R) : Records(R) {}
    
    void run(raw_ostream &OS);
    void populateOperands();
    void populateEnums();
    void populateInstructions();
    void emitPrelude(raw_ostream &OS);
    void emitOperands(raw_ostream &OS);
    void emitEnums(raw_ostream &OS);
    void emitEnumCapability(raw_ostream &OS);
    void emitEnumFollowedLiterals(raw_ostream &OS);
    void emitStorageClassTables(raw_ostream &OS);

    // ImageOperand Dimension table
    // isID MemorySemantics & Scope
    
    // Instruction tables: Core, OpenCL & GLSL450
        // BaseInfo table
        // Capability table
        // Operand table
    
    // Instrinsics bidirectional table

};
}; // annonymous namespace
void SPIRVTableEmitter::populateOperands() {
    
}

void SPIRVTableEmitter::populateEnums() {
    
}

void SPIRVTableEmitter::populateInstructions() {
    
}


void SPIRVTableEmitter::run(raw_ostream &OS) {
    populateOperands();
    populateEnums();
    populateInstructions();
    emitPrelude(OS);
    emitEnums(OS);
    emitEnumCapability(OS);
    emitEnumFollowedLiterals(OS);
    emitStorageClassTables(OS);
}

void SPIRVTableEmitter::emitPrelude(raw_ostream &OS) {
     OS << R"end(
/*Automatically generated by TableGen SPIRVTableEmitter*/
#include "llvm/ADT/ArrayRef.h"

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
        Type,       // Id is a type
        Var,        // a variable
        Const,      // a compile time constant
        SpecConst,  // a specialisation constant
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
        char TagQualExt;
        struct {
            char _Tag  : 2;
            char _Qual : 2;
            char _Ext  : 4;
        };
    };
    Tag      tag()       { return static_cast<Tag>(_Tag); }
    TypeQual qualifier() { return static_cast<TypeQual>(_Qual); }
    TypeExt  ext()       { return static_cast<TypeExt>(_Ext); }
    
    char TypeSpecSection;
    
    Type type() {
        assert(tag() == Tag::ID);
        return static_cast<Type>(TypeSpecSection);
    }
    SpecSection specsection() {
        assert(tag() == Tag::Enum);
        return static_cast<SpecSection>(TypeSpecSection);
    }
    
    Operand(char a, char b) : TagQualExt(a), TypeSpecSection(b) {}
    
};
using OperandList = ArrayRef<Operand>;
)end";

}

void SPIRVTableEmitter::emitEnums(raw_ostream &OS) {
#define EmitEnum(e)\
    OS << "enum class " #e "{\n";\
    for(auto& ee : SPIRVEnums[(int)SpecSection::e]) {\
        OS << ee.name << " = " << ee.Op << ",\n";\
    }\
    OS << "}\n";
    
    EmitEnum(SourceLanguage)
    EmitEnum(ExecutionModel)
    EmitEnum(AddressModel)
    EmitEnum(MemoryModel)
    EmitEnum(ExecutionMode)
    EmitEnum(StorageClass)
    EmitEnum(Dim)
    EmitEnum(SamplerAddressingMode)
    EmitEnum(SamplerFilterMode)
    EmitEnum(ImageFormat)
    EmitEnum(ImageChannelOrder)
    EmitEnum(ImageChannelDataType)
    EmitEnum(ImageOperand)
    EmitEnum(FPFastMathMode)
    EmitEnum(RoundingMode)
    EmitEnum(LinkageType)
    EmitEnum(AccessQualifier)
    EmitEnum(FunctionParameteAttribute)
    EmitEnum(Decoration)
    EmitEnum(BuiltIn)
    EmitEnum(SelectionControl)
    EmitEnum(LoopControl)
    EmitEnum(FunctionControl)
    EmitEnum(MemorySemantics)
    EmitEnum(MemoryAccess)
    EmitEnum(Scope)
    EmitEnum(GroupOperation)
    EmitEnum(KernelEnqueueFlags)
    EmitEnum(KernelProfilingInfo)
    EmitEnum(Capabilities)
    OS << "using CapVec = ArrayRef<Capabilities>;";
#undef EmitEnum
}

void SPIRVTableEmitter::emitEnumCapability(raw_ostream &OS) {
#define EmitEnum(e,c)\
    OS << "CapVec getRequiredCapabilities(" #e " _e) {\n";\
    OS << "\treturn {Capabilities::" #c "};\n}\n";
    EmitEnum(SamplerAddressingMode, Kernel)
    EmitEnum(SamplerFilterMode, Kernel)
    EmitEnum(ImageChannelOrder, Kernel)
    EmitEnum(ImageChannelDataType, Kernel)
    EmitEnum(FPFastMathMode, Kernel)
    EmitEnum(RoundingMode, Kernel)
    EmitEnum(LinkageType, Linkage)
    EmitEnum(AccessQualifier, Kernel)
    EmitEnum(FunctionParameteAttribute, Kernel)
    EmitEnum(GroupOperation, Kernel)
    EmitEnum(KernelEnqueueFlags, Kernel)
    EmitEnum(KernelProfilingFlags, Kernel)
    EmitEnum(KernelProfilingFlags, Kernel)
#undef EmitEnum
#define EmitEnum(e)\
    OS << "CapVec getRequiredCapabilities(" #e " _e) {\n";\
    OS << "\treturn {Capabilities::none};\n}\n";
    EmitEnum(SelectionControl)
    EmitEnum(LoopControl)
    EmitEnum(FunctionControl)
    EmitEnum(MemoryAccess)
    EmitEnum(Scope)
#undef EmitEnum
#define EmitEnum(e)\
    OS << "Capabilities getRequiredCapabilities(" #e " _e) {\n";\
    OS << "\tswitch(_e) {\n";\
    for (auto& ee : SPIRVEnums[(int)SpecSection::e])\
        OS << "\t\tcase " << ee.name <<\
        ": return {staic_cast<Capabilities>(" << (int)ee.Capabilities[0] << ")};\n";\
    OS << "}\n\treturn Capabilities::none;\n}\n";\

    EmitEnum(ExecutionModel)
    EmitEnum(AddressModel)
    EmitEnum(MemoryModel)
    EmitEnum(ExecutionMode)
    EmitEnum(StorageClass)
    EmitEnum(Dim)
    EmitEnum(ImageFormat)
    EmitEnum(ImageOperand)
    EmitEnum(Decoration)
    EmitEnum(BuiltIn)
    EmitEnum(MemorySemantics)
#undef EmitEnum
}

void SPIRVTableEmitter::emitEnumFollowedLiterals(raw_ostream &OS) {
    OS << "template<typename E> OperandList getFollowedLiterals(E e) {\n";
    OS << "\treturn {};";
#define EmitEnum(e)\
    OS << "template<> OperandList getFollowedLiterals<" #e ">(" #e " _e) {";\
    OS << "\tswitch(_e) {\n";\
    for(auto& ee : SPIRVEnums[(int)SpecSection::e]) {\
        OS << "case " << ee.name << ": return {";\
        for(auto& eee : ee.FollowedLiterals)\
            OS << "Operand(" << eee.TagQualExt << ", "<< eee.TypeSpecSection<<");\n"; \
    }\
    OS << "}\n\treturn {};n}";
    EmitEnum(ExecutionMode)
    EmitEnum(Decoration)
    EmitEnum(LoopControl)
    EmitEnum(MemoryAccess)
}

void SPIRVTableEmitter::emitStorageClassTables(raw_ostream &OS) {
    OS << R"end(
enum class OCLAddressSpace {
    Private  = 0,
    Global   = 1,
    Local    = 2,
    Constant = 3,
    Generic  = 4,
    NotApplicable = ~0
};
 /* TODO */
enum class GLSLAddressSpace {
    Private  = 0,
    Constant = 3,
    NotApplicable = ~0
}
    
StorageClass getSPIRVStorageClass(OCLAddressSpace as) {
    switch(as) {
        case OCLAddressSpace::Private:  return StorageClass::Function;
        case OCLAddressSpace::Global:   return StorageClass::CrossWorkgroup;
        case OCLAddressSpace::Local:    return StorageClass::Workgroup;
        case OCLAddressSpace::Constant: return StorageClass::UniformConstant;
        case OCLAddressSpace::Generic:  return StorageClass::Generic;
    }
    return StorageClass::NotApplicable;
}
    
/* TODO: GLSL*/
OCLAddressSpace getOCLAddressSpace(StorageClass sc) {
    switch (sc) {
        case StorageClass::Function:        return OCLAddressSpace::Private;
        case StorageClass::CrossWorkgroup:  return OCLAddressSpace::Global;
        case StorageClass::Workgroup:       return OCLAddressSpace::Local;
        case StorageClass::UniformConstant: return OCLAddressSpace::Constant;
        case StorageClass::Generic:         return OCLAddressSpace::Generic;
    }
   return OCLAddressSpace::NotApplicable;
}
    
)end";
}



