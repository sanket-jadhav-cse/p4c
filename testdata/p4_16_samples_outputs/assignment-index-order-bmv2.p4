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

bit<8> update(inout bit<8> index, in bit<8> value) {
    index = 1;
    return value;
}
H replace(inout bit<8> index) {
    index = 1;
    return (H){value = 0xa3};
}
parser P(packet_in packet, out Headers h, inout Meta m, inout standard_metadata_t sm) {
    bit<8> index;
    state start {
        packet.extract(h.stack[0]);
        packet.extract(h.stack[1]);
        index = 0;
        h.stack[index].value = update(index, 0xa0);
        h.result.setValid();
        h.result.parser_value = h.stack[0].value;
        transition accept;
    }
}

control I(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    bit<8> index;
    action advance() {
        index = 1;
    }
    table t {
        actions = {
            advance;
        }
        const default_action = advance();
    }
    apply {
        index = h.stack[1].value & 1;
        h.stack[index].value = update(index, 0xa1);
        h.result.field_value = h.stack[0].value;
        index = 0;
        h.stack[index ^ 1].value = update(index, 0xa2);
        h.result.expression_value = h.stack[1].value;
        h.stack[0].value = 0x10;
        index = 0;
        h.stack[index].value[3:0] = update(index, 0xb)[3:0];
        h.result.slice_value = h.stack[0].value;
        index = 0;
        h.stack[index] = replace(index);
        h.result.header_value = h.stack[0].value;
        h.stack[0].value = 1;
        h.stack[1].value = 0;
        index = 0;
        h.stack[h.stack[index].value].value = update(index, 0xa4);
        h.result.nested_value = h.stack[1].value;
        h.stack[0].value = 0;
        index = 0;
        h.stack[index].value = (t.apply().hit ? 8w0xa5 : 8w0xa6);
        h.result.table_value = h.stack[0].value;
        sm.egress_spec = 0;
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
        packet.emit(h.result);
    }
}

V1Switch(P(), V(), I(), E(), U(), D()) main;
