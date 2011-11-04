// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests
{
    import flexunit.framework.Assert;
    
    import starling.display.StSprite;
    import starling.events.StEvent;
    import starling.events.StEventDispatcher;
    
    public class EventTest
    {		
        [Test]
        public function testBubbling():void
        {
            const eventType:String = "test";
            
            var grandParent:StSprite = new StSprite();
            var parent:StSprite = new StSprite();
            var child:StSprite = new StSprite();
            
            grandParent.addChild(parent);
            parent.addChild(child);
            
            var grandParentEventHandlerHit:Boolean = false;
            var parentEventHandlerHit:Boolean = false;
            var childEventHandlerHit:Boolean = false;
            var hitCount:int = 0;            
            
            // bubble up
            
            grandParent.addEventListener(eventType, onGrandParentEvent);
            parent.addEventListener(eventType, onParentEvent);
            child.addEventListener(eventType, onChildEvent);
            
            var event:StEvent = new StEvent(eventType, true);
            child.dispatchEvent(event);
            
            Assert.assertTrue(grandParentEventHandlerHit);
            Assert.assertTrue(parentEventHandlerHit);
            Assert.assertTrue(childEventHandlerHit);
            
            Assert.assertEquals(3, hitCount);
            
            // remove event handler
            
            parentEventHandlerHit = false;
            parent.removeEventListener(eventType, onParentEvent);
            child.dispatchEvent(event);
            
            Assert.assertFalse(parentEventHandlerHit);
            Assert.assertEquals(5, hitCount);
            
            // don't bubble
            
            event = new StEvent(eventType);
            
            grandParentEventHandlerHit = parentEventHandlerHit = childEventHandlerHit = false;
            parent.addEventListener(eventType, onParentEvent);
            child.dispatchEvent(event);
            
            Assert.assertEquals(6, hitCount);
            Assert.assertTrue(childEventHandlerHit);
            Assert.assertFalse(parentEventHandlerHit);
            Assert.assertFalse(grandParentEventHandlerHit);
            
            function onGrandParentEvent(event:StEvent):void
            {
                grandParentEventHandlerHit = true;                
                Assert.assertObjectEquals(child, event.target);
                Assert.assertObjectEquals(grandParent, event.currentTarget);
                hitCount++;
            }
            
            function onParentEvent(event:StEvent):void
            {
                parentEventHandlerHit = true;                
                Assert.assertEquals(child, event.target);
                Assert.assertEquals(parent, event.currentTarget);
                hitCount++;
            }
            
            function onChildEvent(event:StEvent):void
            {
                childEventHandlerHit = true;                               
                Assert.assertEquals(child, event.target);
                Assert.assertEquals(child, event.currentTarget);
                hitCount++;
            }
        }
        
        [Test]
        public function testStopPropagation():void
        {
            const eventType:String = "test";
            
            var grandParent:StSprite = new StSprite();
            var parent:StSprite = new StSprite();
            var child:StSprite = new StSprite();
            
            grandParent.addChild(parent);
            parent.addChild(child);
            
            var hitCount:int = 0;
            
            // stop propagation at parent
            
            child.addEventListener(eventType, onEvent);
            parent.addEventListener(eventType, onEvent_StopPropagation);
            parent.addEventListener(eventType, onEvent);
            grandParent.addEventListener(eventType, onEvent);
            
            child.dispatchEvent(new StEvent(eventType, true));
            
            Assert.assertEquals(3, hitCount);
            
            // stop immediate propagation at parent
            
            parent.removeEventListener(eventType, onEvent_StopPropagation);
            parent.removeEventListener(eventType, onEvent);
            
            parent.addEventListener(eventType, onEvent_StopImmediatePropagation);
            parent.addEventListener(eventType, onEvent);
            
            child.dispatchEvent(new StEvent(eventType, true));
            
            Assert.assertEquals(5, hitCount);
            
            function onEvent(event:StEvent):void
            {
                hitCount++;
            }
            
            function onEvent_StopPropagation(event:StEvent):void
            {
                event.stopPropagation();
                hitCount++;
            }
            
            function onEvent_StopImmediatePropagation(event:StEvent):void
            {
                event.stopImmediatePropagation();
                hitCount++;
            }
        }
        
        [Test]
        public function testRemoveEventListeners():void
        {
            var hitCount:int = 0;
            
            var dispatcher:StEventDispatcher = new StEventDispatcher();
            
            dispatcher.addEventListener("Type1", onEvent);
            dispatcher.addEventListener("Type2", onEvent);
            dispatcher.addEventListener("Type2", onEvent);
            dispatcher.addEventListener("Type3", onEvent);
            dispatcher.addEventListener("Type3", onEvent);
            dispatcher.addEventListener("Type3", onEvent);
            
            hitCount = 0;
            dispatcher.dispatchEvent(new StEvent("Type1"));
            Assert.assertEquals(1, hitCount);
            
            hitCount = 0;
            dispatcher.dispatchEvent(new StEvent("Type2"));
            Assert.assertEquals(2, hitCount);
            
            hitCount = 0;
            dispatcher.dispatchEvent(new StEvent("Type3"));
            Assert.assertEquals(3, hitCount);
            
            hitCount = 0;
            dispatcher.removeEventListener("Type1", onEvent);
            dispatcher.dispatchEvent(new StEvent("Type1"));
            Assert.assertEquals(0, hitCount);
            
            hitCount = 0;
            dispatcher.removeEventListeners("Type2");
            dispatcher.dispatchEvent(new StEvent("Type2"));
            Assert.assertEquals(0, hitCount);
            dispatcher.dispatchEvent(new StEvent("Type3"));
            Assert.assertEquals(3, hitCount);
            
            hitCount = 0;
            dispatcher.removeEventListeners();
            dispatcher.dispatchEvent(new StEvent("Type1"));
            dispatcher.dispatchEvent(new StEvent("Type2"));
            dispatcher.dispatchEvent(new StEvent("Type3"));
            Assert.assertEquals(0, hitCount);
            
            function onEvent(event:StEvent):void
            {
                ++hitCount;
            }
        }
        
    }
}
