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

#import <libkern/OSAtomic.h>

typedef struct PLActorReadWriteLockQueueNode {
    id value;
    struct PLActorReadWriteLockQueueNode *next;
} PLActorReadWriteLockQueueNode;

@interface PLActorWriteLockQueue : NSObject <PLActorQueue> {
@private
    /** Head of the queue */
    PLActorReadWriteLockQueueNode *_head;

    /** Tail of the queue */
    PLActorReadWriteLockQueueNode *_tail;

    /** Tail modification lock */
    OSSpinLock _t_lock;
    
    /** Critical section marker. 1 when locked, 0 when unlocked. The critical section
     * is entered before a reader tests if it should sleep waiting for an enqueue, and
     * exited when the reader exits sleep. */
    int32_t _crit;
    
    /** Semaphore used to wake blocked thread in critical section */
    semaphore_t _sem;
    
    /** Non-atomically updated list of previously dequeued nodes. Must only be accessed or
     * modified from the single actor read thread. */
    PLActorReadWriteLockQueueNode *_dequeued;
    
    /** Non-atomically updated pointer to the tail dequeued node. Must only be accessed or
     * modified from the single actor read thread. */
    PLActorReadWriteLockQueueNode *_dequeuedTail;
}

@end
