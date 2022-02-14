//
//  MIKMIDICommandTests.m
//  MIKMIDI
//
//  Created by Andrew Madsen on 11/12/15.
//  Copyright © 2015 Mixed In Key. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MIKMIDI/MIKMIDI.h>

@interface MIKMIDICommandTests : XCTestCase

@end

@implementation MIKMIDICommandTests

- (void)testPolyphonicKeyPressureCommand
{
	Class immutableClass = [MIKMIDIPolyphonicKeyPressureCommand class];
	Class mutableClass = [MIKMutableMIDIPolyphonicKeyPressureCommand class];
	
	MIKMIDIPolyphonicKeyPressureCommand *command = [[immutableClass alloc] init];
	XCTAssert([command isMemberOfClass:[immutableClass class]], @"[[MIKMIDIPolyphonicKeyPressureCommand alloc] init] did not return an MIKMIDIPolyphonicKeyPressureCommand instance.");
	XCTAssert([[MIKMIDICommand commandForCommandType:MIKMIDICommandTypePolyphonicKeyPressure] isMemberOfClass:[immutableClass class]], @"[MIKMIDICommand commandForCommandType:MIKMIDICommandTypePolyphonicKeyPressure] did not return an MIKMIDIPolyphonicKeyPressureCommand instance.");
	XCTAssert([[command copy] isMemberOfClass:[immutableClass class]], @"[MIKMIDIPolyphonicKeyPressureCommand copy] did not return an MIKMIDIPolyphonicKeyPressureCommand instance.");
	XCTAssertEqual(command.commandType, MIKMIDICommandTypePolyphonicKeyPressure, @"[[MIKMIDIPolyphonicKeyPressureCommand alloc] init] produced a command instance with the wrong command type.");
	
	MIKMutableMIDIPolyphonicKeyPressureCommand *mutableCommand = [command mutableCopy];
	XCTAssert([mutableCommand isMemberOfClass:[mutableClass class]], @"-[MIKMIDIPolyphonicKeyPressureCommand mutableCopy] did not return an mutableClass instance.");
	XCTAssert([[mutableCommand copy] isMemberOfClass:[immutableClass class]], @"-[mutableClass mutableCopy] did not return an MIKMIDIPolyphonicKeyPressureCommand instance.");
	
	XCTAssertThrows([(MIKMutableMIDIPolyphonicKeyPressureCommand *)command setNote:64], @"-[MIKMIDIPolyphonicKeyPressureCommand setNote:] was allowed on immutable instance.");
	XCTAssertThrows([(MIKMutableMIDIPolyphonicKeyPressureCommand *)command setPressure:64], @"-[MIKMIDIPolyphonicKeyPressureCommand setPressure:] was allowed on immutable instance.");
	
	XCTAssertNoThrow([mutableCommand setNote:64], @"-[MIKMIDIPolyphonicKeyPressureCommand setNote:] was not allowed on mutable instance.");
	XCTAssertNoThrow([mutableCommand setPressure:64], @"-[MIKMIDIPolyphonicKeyPressureCommand setNote:] was not allowed on mutable instance.");
	
	mutableCommand.note = 42;
	XCTAssertEqual(mutableCommand.note, 42, @"Setting the note on a MIKMutableMIDIPolyphonicKeyPressureCommand instance failed.");
	mutableCommand.pressure = 27;
	XCTAssertEqual(mutableCommand.pressure, 27, @"Setting the pressure on a MIKMutableMIDIPolyphonicKeyPressureCommand instance failed.");
}

- (void)testChannelPressureCommand
{
	Class immutableClass = [MIKMIDIChannelPressureCommand class];
	Class mutableClass = [MIKMutableMIDIChannelPressureCommand class];
	
	MIKMIDIChannelPressureCommand *command = [[immutableClass alloc] init];
	XCTAssert([command isMemberOfClass:[immutableClass class]], @"[[MIKMIDIChannelPressureCommand alloc] init] did not return an MIKMIDIChannelPressureCommand instance.");
	XCTAssert([[MIKMIDICommand commandForCommandType:MIKMIDICommandTypeChannelPressure] isMemberOfClass:[immutableClass class]], @"[MIKMIDICommand commandForCommandType:MIKMIDICommandTypePolyphonicKeyPressure] did not return an MIKMIDIChannelPressureCommand instance.");
	XCTAssert([[command copy] isMemberOfClass:[immutableClass class]], @"[MIKMIDIChannelPressureCommand copy] did not return an MIKMIDIChannelPressureCommand instance.");
	XCTAssertEqual(command.commandType, MIKMIDICommandTypeChannelPressure, @"[[MIKMIDIChannelPressureCommand alloc] init] produced a command instance with the wrong command type.");
	XCTAssertEqual(command.data.length, 2, "MIKMIDIChannelPressureCommand had an incorrect data length %@ (should be 2)", @(command.data.length));
	
	MIKMutableMIDIChannelPressureCommand *mutableCommand = [command mutableCopy];
	XCTAssert([mutableCommand isMemberOfClass:[mutableClass class]], @"-[MIKMIDIChannelPressureCommand mutableCopy] did not return an mutableClass instance.");
	XCTAssert([[mutableCommand copy] isMemberOfClass:[immutableClass class]], @"-[mutableClass mutableCopy] did not return an MIKMIDIChannelPressureCommand instance.");
	
	XCTAssertThrows([(MIKMutableMIDIChannelPressureCommand *)command setPressure:64], @"-[MIKMIDIChannelPressureCommand setPressure:] was allowed on immutable instance.");
	
	XCTAssertNoThrow([mutableCommand setPressure:64], @"-[MIKMIDIChannelPressureCommand setPressure:] was not allowed on mutable instance.");
	
	mutableCommand.pressure = 27;
	XCTAssertEqual(mutableCommand.pressure, 27, @"Setting the pressure on a MIKMutableMIDIChannelPressureCommand instance failed.");
}

- (void)testPitchBendChangeCommand
{
    MIDIPacket packet = MIKMIDIPacketCreate(0, 1, @[@0xef]);
    XCTAssertTrue([[MIKMIDICommand commandWithMIDIPacket:&packet] isKindOfClass:[MIKMIDIPitchBendChangeCommand class]]);

    Class immutableClass = [MIKMIDIPitchBendChangeCommand class];
    Class mutableClass = [MIKMutableMIDIPitchBendChangeCommand class];

    MIKMIDIPitchBendChangeCommand *command = [[immutableClass alloc] init];
    XCTAssert([command isMemberOfClass:[immutableClass class]], @"[[MIKMIDIPitchBendChangeCommand alloc] init] did not return an MIKMIDIPitchBendChangeCommand instance.");
    XCTAssert([[MIKMIDICommand commandForCommandType:MIKMIDICommandTypePitchWheelChange] isMemberOfClass:[immutableClass class]], @"[MIKMIDICommand commandForCommandType:MIKMIDICommandTypeSystemExclusive] did not return an MIKMIDIPitchBendChangeCommand instance.");
    XCTAssert([[command copy] isMemberOfClass:[immutableClass class]], @"[MIKMIDIPitchBendChangeCommand copy] did not return an MIKMIDIPitchBendChangeCommand instance.");
    XCTAssertEqual(command.commandType, MIKMIDICommandTypePitchWheelChange, @"[[MIKMIDIPitchBendChangeCommand alloc] init] produced a command instance with the wrong command type.");
    XCTAssertEqual(command.data.length, 3, "MIKMIDIPitchBendChangeCommand had an incorrect data length %@ (should be 3)", @(command.data.length));

    MIKMutableMIDIPitchBendChangeCommand *mutableCommand = [command mutableCopy];
    XCTAssert([mutableCommand isMemberOfClass:[mutableClass class]], @"-[MIKMIDIPitchBendChangeCommand mutableCopy] did not return an mutableClass instance.");
    XCTAssert([[mutableCommand copy] isMemberOfClass:[immutableClass class]], @"-[mutableClass mutableCopy] did not return an MIKMIDIPitchBendChangeCommand instance.");

    NSDate *date = [NSDate date];
    MIKMIDIPitchBendChangeCommand *convenienceTest = [MIKMIDIPitchBendChangeCommand pitchBendChangeCommandWithPitchChange:42 channel:2 timestamp:date];
    XCTAssertNotNil(convenienceTest);
    XCTAssert([convenienceTest isMemberOfClass:[immutableClass class]], @"[MIKMIDIPitchBendChangeCommand pitchBendChangeCommandWithPitchChange:...] did not return an MIKMIDIPitchBendChangeCommand instance.");
    XCTAssertEqual(convenienceTest.pitchChange, 42);
    XCTAssertEqual(convenienceTest.channel, 2);

    MIKMutableMIDIPitchBendChangeCommand *mutableConvenienceTest = [MIKMutableMIDIPitchBendChangeCommand pitchBendChangeCommandWithPitchChange:42 channel:2 timestamp:date];
    XCTAssertNotNil(mutableConvenienceTest);
    XCTAssert([mutableConvenienceTest isMemberOfClass:[mutableClass class]], @"[MIKMutableMIDIPitchBendChangeCommand pitchBendChangeCommandWithPitchChange:...] did not return an MIKMutableMIDIPitchBendChangeCommand instance.");
    XCTAssertEqual(mutableConvenienceTest.pitchChange, 42);
    XCTAssertEqual(mutableConvenienceTest.channel, 2);
}

- (void)testKeepAliveCommand
{
	MIDIPacket packet = MIKMIDIPacketCreate(0, 1, @[@0xfe]);
	XCTAssertTrue([[MIKMIDICommand commandWithMIDIPacket:&packet] isKindOfClass:[MIKMIDISystemKeepAliveCommand class]]);
	
	Class immutableClass = [MIKMIDISystemKeepAliveCommand class];
	Class mutableClass = [MIKMutableMIDISystemKeepAliveCommand class];
	
	MIKMIDISystemKeepAliveCommand *command = [[immutableClass alloc] init];
	XCTAssert([command isMemberOfClass:[immutableClass class]], @"[[MIKMIDISystemKeepAliveCommand alloc] init] did not return an MIKMIDISystemKeepAliveCommand instance.");
	XCTAssert([[MIKMIDICommand commandForCommandType:MIKMIDICommandTypeSystemKeepAlive] isMemberOfClass:[immutableClass class]], @"[MIKMIDICommand commandForCommandType:MIKMIDICommandTypeSystemExclusive] did not return an MIKMIDISystemKeepAliveCommand instance.");
	XCTAssert([[command copy] isMemberOfClass:[immutableClass class]], @"[MIKMIDISystemKeepAliveCommand copy] did not return an MIKMIDISystemKeepAliveCommand instance.");
	XCTAssertEqual(command.commandType, MIKMIDICommandTypeSystemKeepAlive, @"[[MIKMIDISystemKeepAliveCommand alloc] init] produced a command instance with the wrong command type.");
	XCTAssertEqual(command.data.length, 1, "MIKMIDISystemKeepAliveCommand had an incorrect data length %@ (should be 1)", @(command.data.length));
	
	MIKMutableMIDISystemKeepAliveCommand *mutableCommand = [command mutableCopy];
	XCTAssert([mutableCommand isMemberOfClass:[mutableClass class]], @"-[MIKMIDISystemKeepAliveCommand mutableCopy] did not return an mutableClass instance.");
	XCTAssert([[mutableCommand copy] isMemberOfClass:[immutableClass class]], @"-[mutableClass mutableCopy] did not return an MIKMIDISystemKeepAliveCommand instance.");	
}

- (void)testMMCLocateCommand
{
    NSArray *bytes = @[@(0xf0), @(0x7f), @(0x7f), @(0x06), @(0x44), @(0x06), @(0x01), @(0x21), @(0x00), @(0x00), @(0x00), @(0x00), @(0xf7)];
    MIDIPacket packet = MIKMIDIPacketCreate(0, bytes.count, bytes);

    MIKMIDICommand *command = [MIKMIDICommand commandWithMIDIPacket:&packet];
    XCTAssertTrue([command isMemberOfClass:[MIKMIDIMachineControlLocateCommand class]]);

    bytes = @[@(0xf0), @(0x7f), @(0x7f), @(0x06), @(0x45), @(0x06), @(0x01), @(0x21), @(0x00), @(0x00), @(0x00), @(0x00), @(0xf7)];
    packet = MIKMIDIPacketCreate(0, bytes.count, bytes);
    command = [MIKMIDICommand commandWithMIDIPacket:&packet]; // Should not be a locate command because message type byte is 0x45, not 0x44
    XCTAssertFalse([command isMemberOfClass:[MIKMIDIMachineControlLocateCommand class]]);
}

- (void)testMultipleCommandTypesInOnePacket
{
	MIKMIDINoteOnCommand *noteOn = [MIKMIDINoteOnCommand noteOnCommandWithNote:60 velocity:64 channel:0 timestamp:nil];
	MIKMutableMIDIControlChangeCommand *cc = [MIKMutableMIDIControlChangeCommand controlChangeCommandWithControllerNumber:27 value:63];
	MIKMutableMIDIChannelPressureCommand *pressure = [MIKMutableMIDIChannelPressureCommand channelPressureCommandWithPressure:42 channel:0 timestamp:nil];
	cc.midiTimestamp = noteOn.midiTimestamp; // Messages in a MIDIPacket all have the same timestamp.
	pressure.midiTimestamp = noteOn.midiTimestamp;
	NSArray *commands = @[noteOn, pressure, cc];
	
	MIDIPacket *packet = MIKMIDIPacketCreateFromCommands(cc.midiTimestamp, commands);
	NSArray *parsedCommands = [MIKMIDICommand commandsWithMIDIPacket:packet];
	XCTAssertEqualObjects(commands, parsedCommands, @"Parsing multiple commands from MIDI packet failed to produce original commands.");
	
	MIKMIDIPacketFree(packet);
}

@end
