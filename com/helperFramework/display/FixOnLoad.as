/**
 * Used to fix the AS2 problem with MovieClips linked from the library not firing onLoad or onUnload events.
 * Make the item in the library extends that class to solve that issue.
 * @author bertrandr@funcom.com
 */
class com.helperFramework.display.FixOnLoad extends MovieClip {
  public function onLoad():Void { }
}