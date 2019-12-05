module imgui

pub struct C.ImVec2 {
pub mut:
	x f32
	y f32
}

pub struct C.ImVec4 {
pub mut:
	x f32
	y f32
	z f32
	w f32
}

type ImGuiConfigFlags int
type ImGuiBackendFlags int

pub struct C.ImGuiIO {
pub mut:
    ConfigFlags ImGuiConfigFlags
    BackendFlags ImGuiBackendFlags
    DisplaySize ImVec2
    DeltaTime f32
    IniSavingRate f32
    IniFilename byteptr
    LogFilename byteptr
    MouseDoubleClickTime f32
    MouseDoubleClickMaxDist f32
    MouseDragThreshold f32
/*
    KeyMap [ImGuiKey_COUNT]int
*/
    KeyRepeatDelay f32
    KeyRepeatRate f32
    UserData voidptr
/*
    ImFontAtlas*Fonts
    float FontGlobalScale
    bool FontAllowUserScaling
    ImFont* FontDefault
*/
    DisplayFramebufferScale ImVec2
    MouseDrawCursor bool
    ConfigMacOSXBehaviors bool
    ConfigInputTextCursorBlink bool
    ConfigWindowsResizeFromEdges bool
    ConfigWindowsMoveFromTitleBarOnly bool
    ConfigWindowsMemoryCompactTimer f32
    BackendPlatformName byteptr
    BackendRendererName byteptr
    BackendPlatformUserData voidptr
    BackendRendererUserData voidptr
    BackendLanguageUserData voidptr
/*
    const char* (*GetClipboardTextFn)(void* user_data)
    void (*SetClipboardTextFn)(void* user_data, const char* text)
    void* ClipboardUserData
    void (*ImeSetInputScreenPosFn)(int x, int y)
    void* ImeWindowHandle
    void* RenderDrawListsFnUnused
*/
    MousePos ImVec2
    MouseDown [5]bool
    MouseWheel f32
    MouseWheelH f32
    KeyCtrl bool
    KeyShift bool
    KeyAlt bool
    KeySuper bool
    KeysDown [512]bool
/*
    float NavInputs[ImGuiNavInput_COUNT]
*/
    WantCaptureMouse bool
    WantCaptureKeyboard bool
    WantTextInput bool
    WantSetMousePos bool
    WantSaveIniSettings bool
    NavActive bool
    NavVisible bool
    Framerate f32
    MetricsRenderVertices int
    MetricsRenderIndices int
    MetricsRenderWindows int
    MetricsActiveWindows int
    MetricsActiveAllocations int
    MouseDelta ImVec2
    MousePosPrev ImVec2
    MouseClickedPos [5]ImVec2
    MouseClickedTime [5]f64
    MouseClicked [5]bool
    MouseDoubleClicked [5]bool
    MouseReleased [5]bool
    MouseDownOwned [5]bool
    MouseDownWasDoubleClick [5]bool
    MouseDownDuration [5]f32
    MouseDownDurationPrev [5]f32
    MouseDragMaxDistanceAbs [5]ImVec2
    MouseDragMaxDistanceSqr [5]f32
    KeysDownDuration [512]f32
    KeysDownDurationPrev [512]f32
/*
    float NavInputsDownDuration[ImGuiNavInput_COUNT]
    float NavInputsDownDurationPrev[ImGuiNavInput_COUNT]
    ImVector_ImWchar InputQueueCharacters
*/
}
type ImGuiIo C.ImGuiIO