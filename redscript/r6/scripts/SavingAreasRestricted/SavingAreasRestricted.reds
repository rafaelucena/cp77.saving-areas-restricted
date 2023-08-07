// v1.61.3.1

@addField(PlayerPuppet)
private let m_inDangerousArea: Bool = false;

@addMethod(PlayerPuppet)
public final const func IsInDangerousArea() -> Bool {
  return this.m_inDangerousArea;
}

@replaceMethod(PlayerPuppet)
protected cb func OnZoneChange(value: Variant) -> Bool {
  let securityZoneData: SecurityAreaData = FromVariant<SecurityAreaData>(value);
  GameInstance.GetTelemetrySystem(this.GetGame()).LogPlayerInDangerousArea(Equals(securityZoneData.securityAreaType, ESecurityAreaType.RESTRICTED) || Equals(securityZoneData.securityAreaType, ESecurityAreaType.DANGEROUS));

  this.m_inDangerousArea = Equals(securityZoneData.securityAreaType, ESecurityAreaType.RESTRICTED) || Equals(securityZoneData.securityAreaType, ESecurityAreaType.DANGEROUS);
}

@wrapMethod(PauseMenuGameController)
private final func HandlePressToSaveGame(target: wref<inkWidget>) -> Void {
  let playerPuppet: wref<GameObject> = this.GetPlayerControlledObject();

  if (playerPuppet as PlayerPuppet).IsInDangerousArea() {
    this.PlaySound(n"Button", n"OnPress");
    this.PlayLibraryAnimationOnAutoSelectedTargets(n"pause_button_blocked", target);
    return;
  };

  wrappedMethod(target);
}

@wrapMethod(PauseMenuGameController)
private final func HandlePressToQuickSaveGame() -> Void {
  let playerPuppet: wref<GameObject> = this.GetPlayerControlledObject();

  if (playerPuppet as PlayerPuppet).IsInDangerousArea() {
    this.PlaySound(n"Button", n"OnPress");
    return;
  };

  wrappedMethod();
}

@wrapMethod(gameuiInGameMenuGameController)
private final func HandleQuickSave() -> Void {
  let playerPuppet: wref<GameObject> = this.GetPlayerControlledObject();

  if (playerPuppet as PlayerPuppet).IsInDangerousArea() {
    return;
  };

  wrappedMethod();
}
