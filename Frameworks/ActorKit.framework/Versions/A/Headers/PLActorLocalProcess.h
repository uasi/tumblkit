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

/**
 * @internal
 *
 * Private interfaces that must be provided by actor processes that maintain
 * an incoming message queue and support local message receiption. 
 */
@protocol PLActorLocalProcess <PLActorProcess>

/**
 * Perform a selective receive, using the provided filter function to select the first matching queued message.
 *
 * @param message Returned message.
 * @param filter Message filter function.
 * @param filterContext Message filter context.
 * @param timeout Number of milliseconds to wait. If PLActorTimeWaitNone, will return immediately. If PLActorTimeWaitForever, will wait forever.
 * @return Returns YES if a message was received, NO if timeout was reached and no message was received.
 */
- (BOOL) receive: (id *) message 
     usingFilter: (plactor_receive_filter_t) filter 
   filterContext: (void *) filterContext 
     withTimeout: (PLActorTimeInterval) timeout;

/**
 * Generate a unique transaction ID; the ID must be generally unique within the actor process.
 *
 * @note The generator may roll-over after 2^32-1 IDs are generated.
 */
- (PLActorTxId) createTransactionId;

/**
 * Flush all pending messages from the actor's mailbox.
 *
 * May only be called from the owning thread.
 * Must only be used for unit testing.
 */
- (void) flush;

@end