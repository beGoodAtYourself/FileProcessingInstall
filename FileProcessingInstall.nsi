;================================
; FileProcessing.nsi
; FileProcessing 安装程序脚本
; 版本: 3.0.0
;================================

;--------------------------------
; 编译器配置
;--------------------------------
!include ".\Include\config.nsh"
!define REG_KEY "Software\${PRODUCT_NAME}"
!define REG_UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define INSTALLER_NAME "FileProcessing_${PRODUCT_VERSION}.exe"
!define UNINSTALLER_NAME "Uninstall.exe"
!define APP_EXE_NAME "FileProcessing.exe"

;--------------------------------
; 引入 Modern UI 2
;--------------------------------
!include "MUI2.nsh"

;--------------------------------
; 基础配置
;--------------------------------
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
Caption "${PRODUCT_NAME} ${PRODUCT_VERSION} Setup"
OutFile "${INSTALLER_NAME}"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
InstallDirRegKey HKLM "Software\${PRODUCT_NAME}" "InstallDir"
RequestExecutionLevel admin

;--------------------------------
; MUI2 界面配置
;--------------------------------
!define MUI_ABORTWARNING
!define MUI_ABORTWARNING_TEXT "Are you sure you want to abort the installation?"

; 欢迎页面配置
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${PRODUCT_NAME} ${PRODUCT_VERSION} Setup"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of ${PRODUCT_NAME} ${PRODUCT_VERSION}.$\r$\n$\r$\n${PRODUCT_NAME} is a powerful file processing application.$\r$\n$\r$\nClick Next to continue."

; 许可证页面配置
!define MUI_LICENSEPAGE_TEXT_TOP "Please read the following license agreement carefully before installing."
!define MUI_LICENSEPAGE_TEXT_BOTTOM "If you accept the terms of the agreement, click I Agree to continue. You must accept the agreement to install ${PRODUCT_NAME}."

; 组件选择页面配置
!define MUI_COMPONENTSPAGE_TEXT_TOP_DESCRIPTION "Select the components you want to install. Components marked with a lock are required and cannot be deselected."
!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_INFO "Hover over a component to see its description."

; 安装进度页面配置
!define MUI_INSTFILESPAGE_FINISHHEADER_TEXT "Installation Complete"
!define MUI_INSTFILESPAGE_FINISHHEADER_SUBTEXT "Setup has finished installing ${PRODUCT_NAME} on your computer."
!define MUI_INSTFILESPAGE_ABORTHEADER_TEXT "Installation Aborted"
!define MUI_INSTFILESPAGE_ABORTHEADER_SUBTEXT "Setup did not complete the installation."

; 完成页面配置
!define MUI_FINISHPAGE_TITLE "Completing ${PRODUCT_NAME} ${PRODUCT_VERSION} Setup"
!define MUI_FINISHPAGE_TEXT "${PRODUCT_NAME} ${PRODUCT_VERSION} has been installed on your computer.$\r$\n$\r$\nClick Finish to close Setup."
!define MUI_FINISHPAGE_RUN "$INSTDIR\${APP_EXE_NAME}"
!define MUI_FINISHPAGE_RUN_TEXT "Launch ${PRODUCT_NAME}"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "View Version History"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\VERSION_HISTORY.md"

; 卸载确认页面配置
!define MUI_UNCONFIRMPAGE_TEXT_TOP "Are you sure you want to uninstall ${PRODUCT_NAME}?"
!define MUI_UNCONFIRMPAGE_TEXT_LOCATION "Installation Location:"

; 卸载完成页面配置
!define MUI_UNFINISHPAGE_TITLE "Completing ${PRODUCT_NAME} Uninstall"
!define MUI_UNFINISHPAGE_TEXT "${PRODUCT_NAME} has been uninstalled from your computer.$\r$\n$\r$\nClick Finish to close."

; 图标配置
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\app.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\app.ico"

; 标题栏图片配置
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!define MUI_HEADERIMAGE_RIGHT

; 欢迎页左侧图片配置
!define MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"

;--------------------------------
; MUI2 页面定义（安装）
;--------------------------------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;--------------------------------
; MUI2 页面定义（卸载）
;--------------------------------
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; MUI2 语言配置
;--------------------------------
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
; 安装区段 - 主程序（必装）
;--------------------------------
Section "!Main Program" SEC_MAIN
  ; 必装区段，锁定不可取消
  SectionIn RO

  ; 检查并卸载旧版本
  Call UninstallOldVersion

  ; 设置安装目录
  SetOutPath "$INSTDIR"

  ; 复制程序文件
  File ".\Output\${APP_EXE_NAME}"

  ; 复制库文件
  File ".\Output\heif.dll"

  ; 复制版本历史文档
  File ".\Output\VERSION_HISTORY.md"

  ; 创建卸载程序
  WriteUninstaller "$INSTDIR\${UNINSTALLER_NAME}"

  ; 写入注册表信息 - 用于版本检测和卸载
  WriteRegStr HKLM "${REG_KEY}" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "${REG_KEY}" "Version" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${REG_KEY}" "Publisher" "${PRODUCT_NAME}"

  ; 写入卸载注册表信息
  WriteRegStr HKLM "${REG_UNINSTALL_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "${REG_UNINSTALL_KEY}" "UninstallString" "$INSTDIR\${UNINSTALLER_NAME}"
  WriteRegStr HKLM "${REG_UNINSTALL_KEY}" "QuietUninstallString" "$INSTDIR\${UNINSTALLER_NAME} /S"
  WriteRegStr HKLM "${REG_UNINSTALL_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegStr HKLM "${REG_UNINSTALL_KEY}" "Publisher" "${PRODUCT_NAME}"
  WriteRegStr HKLM "${REG_UNINSTALL_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${REG_UNINSTALL_KEY}" "URLInfoAbout" ""
  WriteRegDWORD HKLM "${REG_UNINSTALL_KEY}" "NoModify" 1
  WriteRegDWORD HKLM "${REG_UNINSTALL_KEY}" "NoRepair" 1

SectionEnd

;--------------------------------
; 安装区段 - 桌面快捷方式（可选）
;--------------------------------
Section "Desktop Shortcut" SEC_DESKTOP
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${APP_EXE_NAME}"
SectionEnd

;--------------------------------
; 安装区段 - 开始菜单快捷方式（可选）
;--------------------------------
Section "Start Menu Shortcut" SEC_STARTMENU
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${APP_EXE_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\${UNINSTALLER_NAME}"
SectionEnd

;--------------------------------
; 组件描述文本
;--------------------------------
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_MAIN} "The core application files required to run ${PRODUCT_NAME}.$\r$\nThis component is mandatory."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_DESKTOP} "Create a shortcut on the Desktop for quick access to ${PRODUCT_NAME}."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_STARTMENU} "Create shortcuts in the Start Menu for ${PRODUCT_NAME} and Uninstall."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; 功能函数 - 检查并卸载旧版本
;--------------------------------
Function UninstallOldVersion
  ; 检查注册表中是否已存在旧版本
  ReadRegStr $R0 HKLM "${REG_KEY}" "Version"
  StrCmp $R0 "" done

  ; 检测到已安装版本，读取卸载路径
  ReadRegStr $R0 HKLM "${REG_UNINSTALL_KEY}" "UninstallString"
  StrCmp $R0 "" done

  ; 确认旧版本存在，执行静默卸载
  MessageBox MB_OKCANCEL|MB_ICONQUESTION "Detected installed version $R0. $\n$\nUninstall old version and continue?" IDOK uninstall
  Abort

uninstall:
  ; 执行静默卸载，等待完成
  ExecWait "$R0 /S _?=$INSTDIR" $R1

  ; 检查卸载结果
  IntCmp $R1 0 done
  MessageBox MB_OK|MB_ICONEXCLAMATION "Failed to uninstall old version (Error: $R1). $\n$\nPlease uninstall manually and try again."
  Abort

done:
FunctionEnd

;--------------------------------
; 安装初始化
;--------------------------------
Function .onInit
  ; 桌面快捷方式默认选中
  SectionSetFlags ${SEC_DESKTOP} ${SF_SELECTED}
  ; 开始菜单快捷方式默认选中
  SectionSetFlags ${SEC_STARTMENU} ${SF_SELECTED}
FunctionEnd

;--------------------------------
; 安装完成回调
;--------------------------------
Function .onInstSuccess
  ; 安装成功，可在此添加额外的成功处理逻辑
FunctionEnd

;--------------------------------
; 卸载区段
;--------------------------------
Section "Uninstall"
  ; 尝试删除正在运行的程序（可选）
  ; FindWindow $0 "FileProcessing"
  ; IsWindow $0 0 +2
  ; SendMessage $0 ${WM_CLOSE} 0 0

  ; 删除桌面快捷方式
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

  ; 删除开始菜单快捷方式及目录
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"

  ; 删除程序文件
  Delete "$INSTDIR\${APP_EXE_NAME}"
  Delete "$INSTDIR\VERSION_HISTORY.md"
  Delete "$INSTDIR\${UNINSTALLER_NAME}"

  ; 删除安装目录
  RMDir /r "$INSTDIR"

  ; 删除注册表信息
  DeleteRegKey HKLM "${REG_KEY}"
  DeleteRegKey HKLM "${REG_UNINSTALL_KEY}"

SectionEnd

;--------------------------------
; 卸载初始化
;--------------------------------
Function un.onInit
  ; 读取安装目录
  ReadRegStr $INSTDIR HKLM "${REG_KEY}" "InstallDir"
FunctionEnd

;--------------------------------
; 安装程序版本信息（资源属性）
;--------------------------------
VIProductVersion "${PRODUCT_VERSION}.0"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "Copyright (C) ${PRODUCT_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${PRODUCT_NAME} Installer"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "OriginalFilename" "${INSTALLER_NAME}"
VIAddVersionKey /LANG=${LANG_ENGLISH} "InternalName" "${PRODUCT_NAME}"
