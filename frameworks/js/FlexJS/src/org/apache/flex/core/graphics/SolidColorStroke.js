/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.core.graphics.SolidColorStroke');


/**
 * @constructor
 */
org.apache.flex.core.graphics.SolidColorStroke = function() {

  /**
   * @private
   * @type {number}
   */
  this.alpha_ = 1.0;
  
  /**
   * @private
   * @type {number}
   */
  this.color_ = 1.0;
  
  /**
   * @private
   * @type {number}
   */
  this.weight_ = 1.0;
    
};

/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.SolidColorStroke.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SolidColorStroke',
                qName: 'org.apache.flex.core.graphics.SolidColorStroke' }] };


/**
 * @expose
 * @return {number} color
 */
org.apache.flex.core.graphics.SolidColorStroke.prototype.get_color = function() {
  return this.color_;
};


/**
 * @param {number} value color
 */
org.apache.flex.core.graphics.SolidColorStroke.prototype.set_color = function(value) {
  this.color_ = value;
};


/**
 * @expose
 * @return {number} alpha
 */
org.apache.flex.core.graphics.SolidColorStroke.prototype.get_alpha = function() {
  return this.alpha_;
};


/**
 * @param {number} value alpha
 */
org.apache.flex.core.graphics.SolidColorStroke.prototype.set_alpha = function(value) {
  this.alpha_ = value;
};

/**
 * @expose
 * @return {number} weight
 */
org.apache.flex.core.graphics.SolidColorStroke.prototype.get_weight = function() {
  return this.weight_;
};


/**
 * @param {number} value weight
 */
org.apache.flex.core.graphics.SolidColorStroke.prototype.set_weight = function(value) {
  this.weight_ = value;
};
