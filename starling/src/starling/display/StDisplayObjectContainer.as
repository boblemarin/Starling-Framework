// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display
{
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getQualifiedClassName;
    
    import starling.core.RenderSupport;
    import starling.errors.AbstractClassError;
    import starling.events.StEvent;
    
    /**
     *  A DisplayObjectContainer represents a collection of display objects.
     *  It is the base class of all display objects that act as a container for other objects. By 
     *  maintaining an ordered list of children, it defines the back-to-front positioning of the 
     *  children within the display tree.
     *  
     *  <p>A container does not a have size in itself. The width and height properties represent the 
     *  extents of its children. Changing those properties will scale all children accordingly.</p>
     *  
     *  <p>As this is an abstract class, you can't instantiate it directly, but have to 
     *  use a subclass instead. The most lightweight container class is "Sprite".</p>
     *  
     *  <strong>Adding and removing children</strong>
     *  
     *  <p>The class defines methods that allow you to add or remove children. When you add a child, 
     *  it will be added at the frontmost position, possibly occluding a child that was added 
     *  before. You can access the children via an index. The first child will have index 0, the 
     *  second child index 1, etc.</p> 
     *  
     *  Adding and removing objects from a container triggers non-bubbling events.
     *  
     *  <ul>
     *   <li><code>Event.ADDED</code>: the object was added to a parent.</li>
     *   <li><code>Event.ADDED_TO_STAGE</code>: the object was added to a parent that is 
     *       connected to the stage, thus becoming visible now.</li>
     *   <li><code>Event.REMOVED</code>: the object was removed from a parent.</li>
     *   <li><code>Event.REMOVED_FROM_STAGE</code>: the object was removed from a parent that 
     *       is connected to the stage, thus becoming invisible now.</li>
     *  </ul>
     *  
     *  Especially the <code>ADDED_TO_STAGE</code> event is very helpful, as it allows you to 
     *  automatically execute some logic (e.g. start an animation) when an object is rendered the 
     *  first time.
     *  
     *  @see Sprite
     *  @see DisplayObject
     */
    public class StDisplayObjectContainer extends StDisplayObject
    {
        // members
        
        private var mChildren:Vector.<StDisplayObject>;
        
        // construction
        
        /** @private */
        public function StDisplayObjectContainer()
        {
            if (getQualifiedClassName(this) == "starling.display::DisplayObjectContainer")
                throw new AbstractClassError();
            
            mChildren = new <StDisplayObject>[];
        }
        
        /** Disposes the resources of all children. */
        public override function dispose():void
        {
            for each (var child:StDisplayObject in mChildren)
                child.dispose();
                
            super.dispose();
        }
        
        // child management
        
        /** Adds a child to the container. It will be at the frontmost position. */
        public function addChild(child:StDisplayObject):void
        {
            addChildAt(child, numChildren);
        }
        
        /** Adds a child to the container at a certain index. */
        public function addChildAt(child:StDisplayObject, index:int):void
        {
            if (index >= 0 && index <= numChildren)
            {
                child.removeFromParent();
                mChildren.splice(index, 0, child);
                child.setParent(this);                
                child.dispatchEvent(new StEvent(StEvent.ADDED, true));
                if (stage) child.dispatchEventOnChildren(new StEvent(StEvent.ADDED_TO_STAGE));
            }
            else
            {
                throw new RangeError("Invalid child index");
            }
        }
        
        /** Removes a child from the container. If the object is not a child, nothing happens. 
         *  If requested, the child will be disposed right away. */
        public function removeChild(child:StDisplayObject, dispose:Boolean=false):void
        {
            var childIndex:int = getChildIndex(child);
            if (childIndex != -1) removeChildAt(childIndex, dispose);
        }
        
        /** Removes a child at a certain index. Children above the child will move down. If
         *  requested, the child will be disposed right away. */
        public function removeChildAt(index:int, dispose:Boolean=false):void
        {
            if (index >= 0 && index < numChildren)
            {
                var child:StDisplayObject = mChildren[index];
                child.dispatchEvent(new StEvent(StEvent.REMOVED, true));
                if (stage) child.dispatchEventOnChildren(new StEvent(StEvent.REMOVED_FROM_STAGE));
                child.setParent(null);
                mChildren.splice(index, 1);
                if (dispose) child.dispose();
            }
            else
            {
                throw new RangeError("Invalid child index");
            }
        }
        
        /** Removes a range of children from the container (endIndex included). 
         *  If no arguments are given, all children will be removed. */
        public function removeChildren(beginIndex:int=0, endIndex:int=-1, dispose:Boolean=false):void
        {
            if (endIndex < 0 || endIndex >= numChildren) 
                endIndex = numChildren - 1;
            
            for (var i:int=beginIndex; i<=endIndex; ++i)
                removeChildAt(beginIndex, dispose);
        }
        
        /** Returns a child object at a certain index. */
        public function getChildAt(index:int):StDisplayObject
        {
            if (index >= 0 && index < numChildren)
                return mChildren[index];
            else
                throw new RangeError("Invalid child index");
        }
        
        /** Returns a child object with a certain name (non-recursively). */
        public function getChildByName(name:String):StDisplayObject
        {
            for each (var currentChild:StDisplayObject in mChildren)
                if (currentChild.name == name) return currentChild;
            return null;
        }
        
        /** Returns the index of a child within the container, or "-1" if it is not found. */
        public function getChildIndex(child:StDisplayObject):int
        {
            return mChildren.indexOf(child);
        }
        
        /** Moves a child to a certain index. Children at and after the replaced position move up.*/
        public function setChildIndex(child:StDisplayObject, index:int):void
        {
            var oldIndex:int = getChildIndex(child);
            if (oldIndex == -1) throw new ArgumentError("Not a child of this container");
            mChildren.splice(oldIndex, 1);
            mChildren.splice(index, 0, child);
        }
        
        /** Swaps the indexes of two children. */
        public function swapChildren(child1:StDisplayObject, child2:StDisplayObject):void
        {
            var index1:int = getChildIndex(child1);
            var index2:int = getChildIndex(child2);
            if (index1 == -1 || index2 == -1) throw new ArgumentError("Not a child of this container");
            swapChildrenAt(index1, index2);
        }
        
        /** Swaps the indexes of two children. */
        public function swapChildrenAt(index1:int, index2:int):void
        {
            var child1:StDisplayObject = getChildAt(index1);
            var child2:StDisplayObject = getChildAt(index2);
            mChildren[index1] = child2;
            mChildren[index2] = child1;
        }
        
        /** Determines if a certain object is a child of the container (recursively). */
        public function contains(child:StDisplayObject):Boolean
        {
            if (child == this) return true;
            
            for each (var currentChild:StDisplayObject in mChildren)
            {
                if (currentChild is StDisplayObjectContainer)
                {
                    if ((currentChild as StDisplayObjectContainer).contains(child)) return true;
                }
                else
                {
                    if (currentChild == child) return true;
                }
            }
            
            return false;
        }
        
        /** @inheritDoc */ 
        public override function getBounds(targetSpace:StDisplayObject):Rectangle
        {
            var numChildren:int = mChildren.length;
            
            if (numChildren == 0)
            {
                var matrix:Matrix = getTransformationMatrix(targetSpace);
                var position:Point = matrix.transformPoint(new Point(x, y));
                return new Rectangle(position.x, position.y);
            }
            else if (numChildren == 1)
            {
                return mChildren[0].getBounds(targetSpace);
            }
            else
            {
                var minX:Number = Number.MAX_VALUE, maxX:Number = -Number.MAX_VALUE;
                var minY:Number = Number.MAX_VALUE, maxY:Number = -Number.MAX_VALUE;
                for each (var child:StDisplayObject in mChildren)
                {
                    var childBounds:Rectangle = child.getBounds(targetSpace);
                    minX = Math.min(minX, childBounds.x);
                    maxX = Math.max(maxX, childBounds.x + childBounds.width);
                    minY = Math.min(minY, childBounds.y);
                    maxY = Math.max(maxY, childBounds.y + childBounds.height);                    
                }
                return new Rectangle(minX, minY, maxX-minX, maxY-minY);
            }                
        }
        
        /** @inheritDoc */
        public override function hitTest(localPoint:Point, forTouch:Boolean=false):StDisplayObject
        {
            if (forTouch && (!visible || !touchable))
                return null;
            
            var numChildren:int = mChildren.length;
            for (var i:int=numChildren-1; i>=0; --i) // front to back!
            {
                var child:StDisplayObject = mChildren[i];
                var transformationMatrix:Matrix = getTransformationMatrix(child);
                var transformedPoint:Point = transformationMatrix.transformPoint(localPoint);
                var target:StDisplayObject = child.hitTest(transformedPoint, forTouch);
                if (target) return target;
            }
            
            return null;
        }
        
        /** @inheritDoc */
        public override function render(support:RenderSupport, alpha:Number):void
        {
            alpha *= this.alpha;
            
            for each (var child:StDisplayObject in mChildren)
            {
                if (child.alpha != 0.0 && child.visible && child.scaleX != 0 && child.scaleY != 0)
                {
                    support.pushMatrix();
                    
                    support.transformMatrix(child);
                    child.render(support, alpha);
                    
                    support.popMatrix();
                }
            }
        }
        
        /** Dispatches an event on all children (recursively). The event must not bubble. */
        public function broadcastEvent(event:StEvent):void
        {
            if (event.bubbles) 
                throw new ArgumentError("Broadcast of bubbling events is prohibited");
            
            dispatchEventOnChildren(event);
        }
        
        /** @private */
        internal override function dispatchEventOnChildren(event:StEvent):void 
        { 
            // the event listeners might modify the display tree, which could make the loop crash. 
            // thus, we collect them in a list and iterate over that list instead.
            
            var listeners:Vector.<StDisplayObject> = new <StDisplayObject>[];
            getChildEventListeners(this, event.type, listeners);
            for each (var listener:StDisplayObject in listeners)
                listener.dispatchEvent(event);
        }
        
        private function getChildEventListeners(object:StDisplayObject, eventType:String, 
                                                listeners:Vector.<StDisplayObject>):void
        {
            var container:StDisplayObjectContainer = object as StDisplayObjectContainer;                
            if (object.hasEventListener(eventType))
                listeners.push(object);
            if (container)
                for each (var child:StDisplayObject in container.mChildren)
                    getChildEventListeners(child, eventType, listeners);
        }
        
        /** The number of children of this container. */
        public function get numChildren():int { return mChildren.length; }        
    }
}