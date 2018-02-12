////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IContainer;
	import org.apache.royale.core.IContentViewHost;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewport;
	import org.apache.royale.core.IViewportModel;
    COMPILE::SWF
    {
        import org.apache.royale.core.IViewportScroller;
		import org.apache.royale.html.beads.ScrollBarView;
		import org.apache.royale.html.beads.models.ScrollBarModel;
		import org.apache.royale.utils.CSSContainerUtils;
		import flash.geom.Rectangle;
		import org.apache.royale.geom.Rectangle;
    }
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.geom.Size;
	import org.apache.royale.geom.Rectangle;

	/**
	 * The VScrollViewport extends the Viewport class by adding horizontal and
	 * vertical scroll bars, if needed, to the content area of a Container. In
	 * addition, the content of the Container is clipped so that items extending
	 * outside the Container are hidden and reachable only by scrolling.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	COMPILE::JS
	public class VScrollViewport extends ScrollingViewport
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function VScrollViewport()
		{
			super();
		}
		
		// These shuould be disabled for VScroll
		// public function get horizontalScrollPosition():Number
		// {
		// 	return this.contentView.positioner.scrollLeft;
		// }
		// public function set horizontalScrollPosition(value:Number):void
		// {
		// 	this.contentView.positioner.scrollLeft = value;
		// }
		
		/**
		 * @royaleignorecoercion HTMLElement 
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (contentView == null) {
				(value as UIBase).element.style.overflow = "hidden";
				(value as UIBase).element.style.overflowY = "auto";
			} else {
				(contentView as UIBase).element.style.overflow = "hidden";
				(contentView as UIBase).element.style.overflowY = "auto";
			}
		}
		
		/**
		* @copy org.apache.royale.core.IViewport
		*/
		override public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
		{
			// does nothing for the JS platform
		}
		
		/**
		 * @copy org.apache.royale.core.IViewport
		 */
		override public function layoutViewportAfterContentLayout(contentSize:Size):void
		{
			// does nothing for the JS platform
		}
	}
	
	COMPILE::SWF
	public class VScrollViewport extends ScrollingViewport
	{
		/**
		 * Constructor
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		public function VScrollViewport()
		{
			super();
		}

		private var _verticalScroller:ScrollBar;

		override public function get verticalScroller():IViewportScroller
		{
			return _verticalScroller;
		}

		private var _horizontalScroller:ScrollBar

		override public function get horizontalScroller():IViewportScroller
		{
			return _horizontalScroller;
		}

        private var _verticalScrollPosition:Number = 0;

        override public function get verticalScrollPosition():Number
        {
			return _verticalScrollPosition;
        }
        override public function set verticalScrollPosition(value:Number):void
        {
			_verticalScrollPosition = value;
			handleVerticalScrollChange();
        }

        private var _horizontalScrollPosition:Number = 0;

        override public function get horizontalScrollPosition():Number
        {
			return _horizontalScrollPosition;
        }
        override public function set horizontalScrollPosition(value:Number):void
        {
			// Do nothing
			// _horizontalScrollPosition = value;
			// handleHorizontalScrollChange();
        }

        private var viewportWidth:Number;
        private var viewportHeight:Number;

        /**
         * @copy org.apache.royale.core.IViewport
         */
        override public function layoutViewportBeforeContentLayout(width:Number, height:Number):void
        {
           	super.layoutViewportBeforeContentLayout(width, height);
           	viewportWidth = width;
           	viewportHeight = height;
        }

        /**
         * @copy org.apache.royale.core.IViewport
         */
		override public function layoutViewportAfterContentLayout(contentSize:Size):void
		{
			var host:UIBase = UIBase(_strand);
			
			var hadV:Boolean = _verticalScroller != null && _verticalScroller.visible;
			// var hadH:Boolean = _horizontalScroller != null && _horizontalScroller.visible;
			
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;
			
			var borderMetrics:org.apache.royale.geom.Rectangle = CSSContainerUtils.getBorderMetrics(_strand);
			
			hostWidth -= borderMetrics.left + borderMetrics.right;
			hostHeight -= borderMetrics.top + borderMetrics.bottom;
			
			var needV:Boolean = contentSize.height > viewportHeight;
			// var needH:Boolean = contentSize.width > viewportWidth;
			
			// if sized to content, the container should stretch to fit, making the original
			// viewport dimensions obsolete and scrollbars unnecessary.
			// This might not work for the flexible child.
			// if (host.isWidthSizedToContent())
			// 	needH = false;
			if (host.isHeightSizedToContent())
				needV = false;

			if (needV)
			{
				if (_verticalScroller == null) {
					_verticalScroller = createVerticalScrollBar();
					(_strand as IContainer).strandChildren.addElement(_verticalScroller);
				}
			}
			// if (needH)
			// {
			// 	if (_horizontalScroller == null) {
			// 		_horizontalScroller = createHorizontalScrollBar();
			// 		(_strand as IContainer).strandChildren.addElement(_horizontalScroller);
			// 	}
			// }
			
			if (needV)
			{
				_verticalScroller.visible = true;
				_verticalScroller.x = UIBase(_strand).width - borderMetrics.right - _verticalScroller.width;
				_verticalScroller.y = borderMetrics.top;
				_verticalScroller.setHeight(hostHeight, false);
				
				ScrollBarModel(_verticalScroller.model).maximum = contentSize.height;
				ScrollBarModel(_verticalScroller.model).pageSize = contentArea.height;
				ScrollBarModel(_verticalScroller.model).pageStepSize = contentArea.height;
				
				if (contentSize.height > contentArea.height &&
					(contentSize.height - contentArea.height) < _verticalScrollPosition)
					_verticalScrollPosition = contentSize.height - contentArea.height;
			}
			else if (_verticalScroller) {
				_verticalScroller.visible = false;
			}
			
			// if (needH)
			// {
			// 	_horizontalScroller.visible = true;
			// 	_horizontalScroller.x = 0;
			// 	_horizontalScroller.y = UIBase(_strand).height - borderMetrics.bottom - _horizontalScroller.height;
			// 	_horizontalScroller.setWidth(hostWidth - (needV ? _verticalScroller.width : 0), false);
				
			// 	ScrollBarModel(_horizontalScroller.model).maximum = contentSize.width;
			// 	ScrollBarModel(_horizontalScroller.model).pageSize = contentArea.width;
			// 	ScrollBarModel(_horizontalScroller.model).pageStepSize = contentArea.width;
				
			// 	if (contentSize.width > contentArea.width &&
			// 		(contentSize.width - contentArea.width) < _horizontalScrollPosition)
			// 		_horizontalScrollPosition = contentSize.width - contentArea.width;
			// } 
			// else if (_horizontalScroller) {
			// 	_horizontalScroller.visible = false;
			// }
			
			var rect:flash.geom.Rectangle = new flash.geom.Rectangle(_horizontalScrollPosition, _verticalScrollPosition,
				(_verticalScroller != null && _verticalScroller.visible) ? _verticalScroller.x : hostWidth,
				hostHeight);
			
			contentArea.scrollRect = rect;
		}

		private function createVerticalScrollBar():ScrollBar
		{
			var vsbm:ScrollBarModel = new ScrollBarModel();
			vsbm.minimum = 0;
			vsbm.snapInterval = 1;
			vsbm.stepSize = 1;
			vsbm.value = 0;

			var vsb:VScrollBar;
			vsb = new VScrollBar();
			vsb.model = vsbm;
			vsb.visible = false;

			vsb.addEventListener("scroll",handleVerticalScroll);
			return vsb;
		}

		// private function createHorizontalScrollBar():ScrollBar
		// {
		// 	var hsbm:ScrollBarModel = new ScrollBarModel();
		// 	hsbm.minimum = 0;
		// 	hsbm.snapInterval = 1;
		// 	hsbm.stepSize = 1;
		// 	hsbm.value = 0;

		// 	var hsb:HScrollBar;
		// 	hsb = new HScrollBar();
		// 	hsb.model = hsbm;
		// 	hsb.visible = false;

		// 	hsb.addEventListener("scroll",handleHorizontalScroll);
		// 	return hsb;
		// }

		private function handleVerticalScroll(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var vpos:Number = ScrollBarModel(_verticalScroller.model).value;
			var rect:flash.geom.Rectangle = contentArea.scrollRect;
			rect.y = vpos;
			contentArea.scrollRect = rect;

			_verticalScrollPosition = vpos;
		}

		// private function handleHorizontalScroll(event:Event):void
		// {
		// 	var host:UIBase = UIBase(_strand);
		// 	var hpos:Number = ScrollBarModel(_horizontalScroller.model).value;
		// 	var rect:flash.geom.Rectangle = contentArea.scrollRect;
		// 	rect.x = hpos;
		// 	contentArea.scrollRect = rect;

		// 	_horizontalScrollPosition = hpos;
		// }

		private function handleVerticalScrollChange():void
		{
			if (_verticalScroller) {
				ScrollBarModel(_verticalScroller.model).value = verticalScrollPosition;
			}
		}

		// private function handleHorizontalScrollChange():void
		// {
		// 	if (_horizontalScroller) {
		// 		ScrollBarModel(_horizontalScroller.model).value = horizontalScrollPosition;
		// 	}
		// }
	}
}