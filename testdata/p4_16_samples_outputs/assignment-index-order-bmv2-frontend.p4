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
    @name("P.index") bit<8> index_8;
    @name("P.tmp") bit<8> tmp;
    @name("P.value_0") bit<8> value_5;
    @name("P.retval") bit<8> retval;
    @name("P.inlinedRetval") bit<8> inlinedRetval_5;
    state start {
        packet.extract<H>(h.stack[0]);
        packet.extract<H>(h.stack[1]);
        index_8 = 8w0;
        tmp = index_8;
        value_5 = 8w0xa0;
        retval = value_5;
        inlinedRetval_5 = retval;
        h.stack[tmp].value = inlinedRetval_5;
        h.result.setValid();
        h.result.parser_value = h.stack[0].value;
        transition accept;
    }
}

control I(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    @name("I.index") bit<8> index_10;
    @name("I.tmp_0") bit<8> tmp_0;
    @name("I.tmp_1") bit<8> tmp_1;
    @name("I.tmp_2") bit<8> tmp_2;
    @name("I.tmp_3") bit<8> tmp_3;
    @name("I.tmp_4") bit<8> tmp_4;
    @name("I.tmp_5") bit<8> tmp_5;
    @name("I.tmp_6") bit<8> tmp_6;
    @name("I.tmp_7") bit<8> tmp_7;
    @name("I.tmp_8") bool tmp_8;
    @name("I.tmp_9") bit<8> tmp_9;
    @name("I.value_1") bit<8> value_6;
    @name("I.retval") bit<8> retval_0;
    @name("I.inlinedRetval_0") bit<8> inlinedRetval_6;
    @name("I.value_2") bit<8> value_7;
    @name("I.retval") bit<8> retval_3;
    @name("I.inlinedRetval_1") bit<8> inlinedRetval_7;
    @name("I.value_3") bit<8> value_8;
    @name("I.retval") bit<8> retval_4;
    @name("I.inlinedRetval_2") bit<8> inlinedRetval_8;
    @name("I.retval_0") H retval_5;
    @name("I.inlinedRetval_3") H inlinedRetval_9;
    @name("I.value_4") bit<8> value_9;
    @name("I.retval") bit<8> retval_6;
    @name("I.inlinedRetval_4") bit<8> inlinedRetval_10;
    @name("I.advance") action advance_1() {
    }
    @name("I.t") table t_0 {
        actions = {
            advance_1();
        }
        const default_action = advance_1();
    }
    apply {
        index_10 = h.stack[1].value & 8w1;
        tmp_0 = index_10;
        value_6 = 8w0xa1;
        retval_0 = value_6;
        inlinedRetval_6 = retval_0;
        h.stack[tmp_0].value = inlinedRetval_6;
        h.result.field_value = h.stack[0].value;
        index_10 = 8w0;
        tmp_1 = index_10 ^ 8w1;
        value_7 = 8w0xa2;
        retval_3 = value_7;
        inlinedRetval_7 = retval_3;
        h.stack[tmp_1].value = inlinedRetval_7;
        h.result.expression_value = h.stack[1].value;
        h.stack[0].value = 8w0x10;
        index_10 = 8w0;
        tmp_2 = index_10;
        value_8 = 8w0xb;
        retval_4 = value_8;
        inlinedRetval_8 = retval_4;
        tmp_3 = inlinedRetval_8;
        h.stack[tmp_2].value[3:0] = tmp_3[3:0];
        h.result.slice_value = h.stack[0].value;
        index_10 = 8w0;
        tmp_4 = index_10;
        retval_5.setValid();
        retval_5 = (H){value = 8w0xa3};
        inlinedRetval_9 = retval_5;
        h.stack[tmp_4] = inlinedRetval_9;
        h.result.header_value = h.stack[0].value;
        h.stack[0].value = 8w1;
        h.stack[1].value = 8w0;
        index_10 = 8w0;
        tmp_5 = index_10;
        tmp_6 = h.stack[tmp_5].value;
        value_9 = 8w0xa4;
        retval_6 = value_9;
        inlinedRetval_10 = retval_6;
        h.stack[tmp_6].value = inlinedRetval_10;
        h.result.nested_value = h.stack[1].value;
        h.stack[0].value = 8w0;
        index_10 = 8w0;
        tmp_7 = index_10;
        tmp_8 = t_0.apply().hit;
        if (tmp_8) {
            tmp_9 = 8w0xa5;
        } else {
            tmp_9 = 8w0xa6;
        }
        h.stack[tmp_7].value = tmp_9;
        h.result.table_value = h.stack[0].value;
        sm.egress_spec = 9w0;
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
