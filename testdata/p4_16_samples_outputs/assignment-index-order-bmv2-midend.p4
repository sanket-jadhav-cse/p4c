#include <core.p4>
#define V1MODEL_VERSION 20180101
#include <v1model.p4>

header H {
    bit<8> value;
}

header Result {
    bit<8> parser_value;
    bit<8> field_value;
    bit<8> expression_value;
    bit<8> slice_value;
    bit<8> header_value;
    bit<8> nested_value;
    bit<8> table_value;
}

struct Headers {
    H[2]   stack;
    Result result;
}

struct Meta {
}

parser P(packet_in packet, out Headers h, inout Meta m, inout standard_metadata_t sm) {
    state start {
        packet.extract<H>(h.stack[0]);
        packet.extract<H>(h.stack[1]);
        h.stack[8w0].value = 8w0xa0;
        h.result.setValid();
        h.result.parser_value = 8w0xa0;
        transition accept;
    }
}

control I(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    @name("I.tmp_0") bit<8> tmp_0;
    @name("I.tmp_8") bool tmp_8;
    @name("I.tmp_9") bit<8> tmp_9;
    @name("I.retval_0") H retval_5;
    @name("I.advance") action advance_1() {
    }
    @name("I.t") table t_0 {
        actions = {
            advance_1();
        }
        const default_action = advance_1();
    }
    @hidden action assignmentindexorderbmv2l56() {
        h.stack[8w0].value = 8w0xa1;
    }
    @hidden action assignmentindexorderbmv2l56_0() {
        h.stack[8w1].value = 8w0xa1;
    }
    @hidden action assignmentindexorderbmv2l56_1() {
        tmp_0 = h.stack[1].value & 8w1;
    }
    @hidden action assignmentindexorderbmv2l80() {
        tmp_8 = true;
    }
    @hidden action assignmentindexorderbmv2l80_0() {
        tmp_8 = false;
    }
    @hidden action assignmentindexorderbmv2l30() {
        h.result.field_value = h.stack[0].value;
        h.stack[8w1].value = 8w0xa2;
        h.result.expression_value = 8w0xa2;
        h.stack[0].value = 8w0x10;
        h.stack[8w0].value[3:0] = 4w0xb;
        h.result.slice_value = h.stack[0].value;
        retval_5.setValid();
        retval_5.value = 8w0xa3;
        h.stack[8w0] = retval_5;
        h.result.header_value = h.stack[0].value;
        h.stack[0].value = 8w1;
        h.stack[1].value = 8w0;
        h.stack[8w1].value = 8w0xa4;
        h.result.nested_value = 8w0xa4;
        h.stack[0].value = 8w0;
    }
    @hidden action assignmentindexorderbmv2l80_1() {
        tmp_9 = 8w0xa5;
    }
    @hidden action assignmentindexorderbmv2l80_2() {
        tmp_9 = 8w0xa6;
    }
    @hidden action assignmentindexorderbmv2l80_3() {
        h.stack[8w0].value = tmp_9;
        h.result.table_value = tmp_9;
        sm.egress_spec = 9w0;
    }
    @hidden table tbl_assignmentindexorderbmv2l56 {
        actions = {
            assignmentindexorderbmv2l56_1();
        }
        const default_action = assignmentindexorderbmv2l56_1();
    }
    @hidden table tbl_assignmentindexorderbmv2l56_0 {
        actions = {
            assignmentindexorderbmv2l56();
        }
        const default_action = assignmentindexorderbmv2l56();
    }
    @hidden table tbl_assignmentindexorderbmv2l56_1 {
        actions = {
            assignmentindexorderbmv2l56_0();
        }
        const default_action = assignmentindexorderbmv2l56_0();
    }
    @hidden table tbl_assignmentindexorderbmv2l30 {
        actions = {
            assignmentindexorderbmv2l30();
        }
        const default_action = assignmentindexorderbmv2l30();
    }
    @hidden table tbl_assignmentindexorderbmv2l80 {
        actions = {
            assignmentindexorderbmv2l80();
        }
        const default_action = assignmentindexorderbmv2l80();
    }
    @hidden table tbl_assignmentindexorderbmv2l80_0 {
        actions = {
            assignmentindexorderbmv2l80_0();
        }
        const default_action = assignmentindexorderbmv2l80_0();
    }
    @hidden table tbl_assignmentindexorderbmv2l80_1 {
        actions = {
            assignmentindexorderbmv2l80_1();
        }
        const default_action = assignmentindexorderbmv2l80_1();
    }
    @hidden table tbl_assignmentindexorderbmv2l80_2 {
        actions = {
            assignmentindexorderbmv2l80_2();
        }
        const default_action = assignmentindexorderbmv2l80_2();
    }
    @hidden table tbl_assignmentindexorderbmv2l80_3 {
        actions = {
            assignmentindexorderbmv2l80_3();
        }
        const default_action = assignmentindexorderbmv2l80_3();
    }
    apply {
        tbl_assignmentindexorderbmv2l56.apply();
        if (tmp_0 == 8w0) {
            tbl_assignmentindexorderbmv2l56_0.apply();
        } else if (tmp_0 == 8w1) {
            tbl_assignmentindexorderbmv2l56_1.apply();
        }
        tbl_assignmentindexorderbmv2l30.apply();
        if (t_0.apply().hit) {
            tbl_assignmentindexorderbmv2l80.apply();
        } else {
            tbl_assignmentindexorderbmv2l80_0.apply();
        }
        if (tmp_8) {
            tbl_assignmentindexorderbmv2l80_1.apply();
        } else {
            tbl_assignmentindexorderbmv2l80_2.apply();
        }
        tbl_assignmentindexorderbmv2l80_3.apply();
    }
}

control E(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}

control V(inout Headers h, inout Meta m) {
    apply {
    }
}

control U(inout Headers h, inout Meta m) {
    apply {
    }
}

control D(packet_out packet, in Headers h) {
    apply {
        packet.emit<Result>(h.result);
    }
}

V1Switch<Headers, Meta>(P(), V(), I(), E(), U(), D()) main;
