/*
 * Author: Landon Fuller <landonf@plausiblelabs.com>
 * Copyright (c) 2008 Plausible Labs Cooperative, Inc.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>

#include <TargetConditionals.h>

#include <pthread.h>

#import <mach/mach.h>
#import <mach/semaphore.h>

/**
 * @defgroup functions Functions Reference
 */

/**
 * @defgroup constants Constants Reference
 */

/**
 * @defgroup types Types Reference
 * @ingroup constants
 */

/**
 * @defgroup enums Enumerations
 * @ingroup constants
 */

/**
 * @defgroup globals Global Variables
 * @ingroup constants
 */

/**
 * @defgroup exceptions Exceptions
 * @ingroup constants
 */


/* Exceptions */
extern NSString *PLActorException;

/* Error Domain and Codes */
extern NSString *PLActorErrorDomain;


/**
 * NSError codes in the Plausible Actor error domain.
 * @ingroup enums
 */
typedef enum {
    /** An unknown error has occured. If this
     * code is received, it is a bug, and should be reported. */
    PLActorErrorUnknown = 0,
} PLActorError;

/**
 * Per-actor unique transaction ID. May be used
 * to differentiate RPC requests.
 *
 * @ingroup types
 */
typedef uint32_t PLActorTxId;


/**
 * Used to specify a time interval, in milliseconds.
 * @ingroup types
 */
typedef uint32_t PLActorTimeInterval;

/**
 * @defgroup constants_plactor_timewait PLActorTimeInterval Constants
 *
 * Time interval constants.
 *
 * @ingroup constants
 * @{
 */

/**
 * Wait forever.
 */
#define PLActorTimeWaitForever -1

/**
 * Do not wait.
 */
#define PLActorTimeWaitNone 0

/**
 * @} constants_plactor_timewait
 */

/* iPhone does not have NSPredicate */
#if !TARGET_OS_IPHONE
#define HAVE_NSPREDICATE 1
#endif

/* Functions */

/**
 * @ingroup functions
 *
 * A selective receive filter function. Must return YES if the message
 * matches the filter, or NO otherwise.
 *
 * @param message Message to test.
 * @param context User-supplied context.
 */
typedef BOOL (*plactor_receive_filter_t) (id message, void *context);


/* Library Includes */
#import "PLActorKit.h"
#import "PLActorProcess.h"
#import "PLActorMessage.h"

#import "PLActorRPC.h"
#import "PLActorRPCProxy.h"
#import "PLRunloopRPCProxy.h"

/* Private API */
#ifdef ACTOR_PRIVATE_API

#import "PLActorQueue.h"
#import "PLActorSimpleQueue.h"

#import "PLActorWriteLockQueue.h"

#import "PLActorLocalProcess.h"

#import "PLSimpleActorProcess.h"
#import "PLThreadedActorProcess.h"

#endif /* ACTOR_PRIVATE_API */

/**
 * @mainpage Plausible ActorKit
 *
 * @section intro_sec Introduction
 *
 * ActorKit provides an Objective-C implementation of asynchronous inter-thread message passing.
 *
 * The purpose of ActorKit is to facilitate the implementation of concurrent software on both the desktop (Mac OS X)
 * and embedded devices (iPhone OS). On the iPhone, thread-based concurrency is a critical tool in
 * achieving high interface responsiveness while implementing long-running and potentially computationally expensive
 * background processing. On Mac OS X, thread-based concurrency opens the door to leveraging the power of
 * increasingly prevalent multi-core desktop computers.
 *
 * To this end, ActorKit endeavours to provide easily understandable invariants for concurrent software:
 *
 * - All threads are actors.
 * - Any actor may create additional actors.
 * - Any actor may asynchronously deliver a message to another actor.
 * - An actor may synchronously wait for message delivery from another actor.
 *
 * As an actor may only synchronously receive messages, no additional concurrency primitives are required, such as mutexes or
 * condition variables.
 *
 * Building on this base concurrency model, ActorKit provides facilities for proxying Objective-C method invocations
 * between threads, providing direct, transparent, synchronous and asynchronous execution of Objective-C methods
 * on actor threads.
 *
 * @section actor_basics Actor Creation and Simple Message Passing
 *
 * @subsection actor_basics_messages Messages
 *
 * The Actor model of concurrency is fundamentally based on communication between isolated actors through
 * asynchronous message passing. In ActorKit, any Objective-C object conforming to the NSObject protocol may
 * be used as an inter-actor message, but message objects should be immutable to ensure thread safety. ActorKit, being written
 * in Objective-C, can not enforce message immutablity or full isolation of Actor threads. It is entirely possible to
 * pass mutable messages, or access mutable global variables. Like many other libraries implementing Actor message passing
 * semantics, isolation is maintained purely through convention.
 *
 * While ActorKit supports messaging with any Objective-C object, the PLActorMessage class provides generally useful
 * facilities such as unique message transaction ids, automatically determining the message sender, and including
 * additional message payloads.
 *
 * @subsection actor_basics_processes Actor Proceses
 *
 * In ActorKit, all threads are fully functioning actors -- including the "main" Cocoa thread. Each actor
 * is represented by a PLActorProcess instance, which may be passed to any other running actors, and is
 * used to send messages asynchronously to the given process.
 *
 * ActorKit ensures that all message reception within a given actor occurs serially, and provides
 * strict guarantees on message ordering -- messages M1 and M2 sent from actor A1 will be delivered to
 * actor A2 in the same order. However, delivery of messages from actor A1 may be interspersed
 * with delivery of messages sent by other actors:
 *
 * @msc
 * Actor1,Actor3,Actor2;
 * Actor1=>Actor3 [label="msg=\"M1\""];
 * Actor2=>Actor3 [label="msg=\"M3\""];
 * Actor1=>Actor3 [label="msg=\"M2\""];
 * @endmsc
 *
 * In the future, ActorKit may be extended to leverage Apple's Grand Central [1] to provide hybrid event/thread M:N scheduling
 * of actor execution on available cores, an approach presented by Philipp Haller and Martin Odersky and implemented
 * in Scala's Actor library [2].
 *
 * @subsection actor_basics_example A Simple Echo Actor
 *
 * @code
 *  - (void) echo {
 *     NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
 *     PLActorMessage *message;
 *
 *     // Loop forever, receiving messages
 *     while ((message = [PLActorKit receive]) != nil) {
 *         // Echo the same message back to the sender.
 *         [[message sender] send: message];
 *
 *         // Flush the autorelease pool through every loop iteration
 *         [pool release];
 *         pool = [[NSAutoreleasePool alloc] init];
 *     }
 *
 *     [pool release];
 * }
 *
 * - (void) run {
 *     // Spawn a new actor thread. This will return a process instance which may be used
 *     // to deliver messages the new actor.
 *     id<PLActorProcess> proc = [PLActorKit spawnWithTarget: self selector: @selector(echo:)];
 *
 *     // Send a simple message to the actor.
 *     [proc send: [PLActorMessage messageWithObject: @"Hello"]];
 *
 *     // Wait for the echo
 *     PLActorMessage *message = [PLActorKit receive];
 * }
 *
 * @endcode
 *
 * @section actor_rpc Sending Synchronous Messages with Actors
 *
 * In an Actor system where all messages are sent asynchronously, synchronous messaging may be achieved 
 * with the following steps:
 *
 * - Allocate a unique transaction id
 * - Send a message with that transaction id
 * - Wait for a reply with a matching transaction id.
 *
 * Message Sequence:
 * @msc
 * Actor1,Actor2;
 * Actor1=>Actor2 [label="msg=\"Hello A2\" sender=Actor1 txid=5"];
 * --- [label="Actor1 Waiting for response"];
 * Actor1<=Actor2 [label="msg=\"Hello A1\" sender=Actor2 txid=5"];
 * @endmsc
 *
 * ActorKit provides facilities for handling this common usage scenario. Unique transaction ids may be generated
 * via the PLActorKit::createTransactionId method, and every PLActorMessage generates and uses a new transactionId.
 * 
 * The PLActorRPC class utilizes the PLActorMessage's transaction id to wait for a reply on your behalf.
 *
 * Send a message, and wait for the reply:
 * @code
 * id<PLActorProcess> helloActor = [PLActorKit spawnWithTarget: self selector: @selector(helloActor:)];
 * PLActorMessage *message = [PLActorMessage messageWithObject: @"Hello"];
 * PLActorMessage *reply = [PLActorRPC sendRPC: message toProcess: helloActor];
 * @endcode
 *
 * @section actor_rpc_objc Transparently Proxying Objective-C Messages with Actors
 *
 * ActorKit provides two NSProxy subclasses which provide \b transparent proxying of Objective-C synchronous
 * and asynchronous method invocations via actor messaging. PLActorRPCProxy spawns a new actor to execute Objective-C
 * methods for a given object instance, while PLRunloopRPCProxy executes Objective-C methods on a provided NSRunLoop.
 *
 * In combination, these classes allow for safely and transparenty executing methods on Objective-C
 * instances from any thread:
 *
 * @code
 * NSString *actorString = [PLActorRPCProxy proxyWithTarget: @"Hello"];
 * NSString *runloopString = [PLRunloopRPCProxy proxyWithTarget: @"Hello" runLoop: [NSRunLoop mainRunLoop]];
 *
 * // Executes synchronously, via a newly created actor thread.
 * [actorString description];
 *
 * // Executes synchronously, on the main runloop.
 * [runloopString description];
 *
 * @endcode
 *
 * By default, PLActorRPCProxy and PLRunloopRPCProxy will execute methods synchronously, waiting
 * for completion prior to returning. In order to execute a method asynchronously -- allowing a long
 * running method to execute without waiting for completion -- it is necessary to mark methods for
 * asynchronous execution.
 *
 * The Objective-C runtime provides a number of type qualifiers that were intended for use in
 * implementing a Distributed Object system. Of particular note is the 'oneway' qualifier, which allows
 * us to specify that a method should be invoked asynchronously.
 *
 * When a method is declared with a return value of 'oneway void', the proxy classes will introspect this return
 * value, and execute the method asynchronously, without waiting for a reply:
 *
 * @code
 * - (oneway void) asyncMethod {
 *    // Execute, asynchronously
 * }
 * @endcode
 *
 * @msc
 * Actor1, PLActorRPCProxy, Actor2;
 *
 * Actor1 => PLActorRPCProxy [label="[Actor2 asyncMethod]"];
 * PLActorRPCProxy => Actor2 [label="[Actor2 asyncMethod]"];
 * @endmsc
 *
 * @code
 * - (NSString *) synchronousMethod {
 *    // Execute, synchronously
 *    return @"Hello";
 * }
 * @endcode
 *
 * @msc
 * Actor1, PLActorRPCProxy, Actor2;
 *
 * Actor1 => PLActorRPCProxy [label="[Actor2 synchronousMethod]"];
 * PLActorRPCProxy => Actor2 [label="[Actor2 synchronousMethod]"];
 * --- [label="Actor1 waiting for result, Actor2 executing"];
 * Actor2 >> PLActorRPCProxy [label="Result: <NSString>"];
 * PLActorRPCProxy >> Actor1 [label="Result: <NSString>"];
 * @endmsc
 *
 * @subsection actor_rpc_objc_example A Simple Echo Actor with PLActorRPCProxy
 *
 * The following actor returns a proxy from its init method, ensuring that all methods
 * called on the object instance will occur via the actor thread.
 *
 * @code
 *
 * // An actor that responds to Objective-C messages either synchronously or asynchronously.
 * @implementation EchoActor
 *
 * - (id) init {
 *     if ((self = [super init]) == nil)
 *         return nil;
 * 
 *     // Launch our actor
 *     id proxy = [[PLActorRPCProxy alloc] initWithTarget: self];
 *
 *     // Release ourself, as the proxy has retained our object,
 *     // and return our proxy to the caller
 *     [self release];
 *     return proxy;
 * }
 *
 * // Method is called asynchronously
 * - (oneway void) asynchronousEcho: (NSString *) text listener: (EchoListener *) echoListener {
 *     [echoListener receiveEcho: text];
 * }
 *
 * // Method is called synchronously
 * - (NSString *) synchronousEcho: (NSString *) text {
 *     return text;
 * }
 *
 * @end
 *
 * @endcode
 *
 * @section services Integration & Development Services
 * ActorKit is provided free of charge under the MIT license, and may be freely integrated with any application.
 * We can provide assistance with integrating our code in your own iPhone or Mac application, as well as development of additional features under
 * a license of your choosing.
 *
 * Contact Plausible Labs for more information: http://www.plausiblelabs.com
 *
 * @section References
 *
 * [1] Grand Central (technology), Wikipedia contributors, Wikipedia, The Free Encyclopedia, November 19, 2008, 17:13 UTC. Available from
 * <a href="http://en.wikipedia.org/w/index.php?title=Grand_Central_(technology)&oldid=252808705">http://en.wikipedia.org/w/index.php?title=Grand_Central_(technology)&oldid=252808705</a>. Accessed November 19, 2008.
 *
 * [2] Actors that Unify Threads and Events, Philipp Haller and Martin Odersky, LAMP-REPORT-2007-001, EPFL, January 2007. Available from
 * <a href="http://lamp.epfl.ch/~phaller/actors.html">http://lamp.epfl.ch/~phaller/actors.html</a>.
 */


/**
 * @page error_handling Error Handling Programming Guide
 *
 * All returned errors will be a member of one of the below defined domains, however, new domains and error codes may be added at any time.
 * If you do not wish to report on the error cause, many methods support a simple form that requires no NSError argument.
 *
 * @section Error Domains, Codes, and User Info
 */
