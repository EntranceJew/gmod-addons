hook.Add("PreRender","FlushLODNoCrash",function()
    local re_enable_mcore = GetConVar("gmod_mcore_test"):GetString() == "1"
    if re_enable_mcore then
      RunConsoleCommand("gmod_mcore_test", "0")
    end
    RunConsoleCommand("r_flushlod")
    if re_enable_mcore then
      RunConsoleCommand("gmod_mcore_test", "1")
    end
    hook.Remove("PreRender","FlushLODNoCrash")
    return true
  end)