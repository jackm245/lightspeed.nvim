local api = vim.api
local contains_3f = vim.tbl_contains
local empty_3f = vim.tbl_isempty
local map = vim.tbl_map
local _local_1_ = math
local abs = _local_1_["abs"]
local ceil = _local_1_["ceil"]
local max = _local_1_["max"]
local min = _local_1_["min"]
local pow = _local_1_["pow"]
local function inc(x)
  return (x + 1)
end
local function dec(x)
  return (x - 1)
end
local function clamp(val, min0, max0)
  if (val < min0) then
    return min0
  elseif (val > max0) then
    return max0
  elseif "else" then
    return val
  end
end
local function last(tbl)
  return tbl[#tbl]
end
local function echo(msg)
  vim.cmd("redraw")
  return api.nvim_echo({{msg}}, false, {})
end
local function replace_keycodes(s)
  return api.nvim_replace_termcodes(s, true, false, true)
end
local _3cbackspace_3e = replace_keycodes("<bs>")
local _3cctrl_v_3e = replace_keycodes("<c-v>")
local function get_motion_force(mode)
  local _3_
  if mode:match("o") then
    _3_ = mode:sub(-1)
  else
  _3_ = nil
  end
  if (nil ~= _3_) then
    local last_ch = _3_
    if ((last_ch == _3cctrl_v_3e) or (last_ch == "V") or (last_ch == "v")) then
      return last_ch
    end
  end
end
local function operator_pending_mode_3f()
  return string.match(api.nvim_get_mode().mode, "o")
end
local function change_operation_3f()
  return (operator_pending_mode_3f() and (vim.v.operator == "c"))
end
local function get_cursor_pos()
  return {vim.fn.line("."), vim.fn.col(".")}
end
local function same_pos_3f(_7_, _9_)
  local _arg_8_ = _7_
  local l1 = _arg_8_[1]
  local c1 = _arg_8_[2]
  local _arg_10_ = _9_
  local l2 = _arg_10_[1]
  local c2 = _arg_10_[2]
  return ((l1 == l2) and (c1 == c2))
end
local function char_at_pos(_11_, _13_)
  local _arg_12_ = _11_
  local line = _arg_12_[1]
  local byte_col = _arg_12_[2]
  local _arg_14_ = _13_
  local char_offset = _arg_14_["char-offset"]
  local line_str = vim.fn.getline(line)
  local char_idx = vim.fn.charidx(line_str, dec(byte_col))
  local char_nr = vim.fn.strgetchar(line_str, (char_idx + (char_offset or 0)))
  if (char_nr ~= -1) then
    return vim.fn.nr2char(char_nr)
  end
end
local function leftmost_editable_wincol()
  local view = vim.fn.winsaveview()
  vim.cmd("norm! 0")
  local wincol = vim.fn.wincol()
  vim.fn.winrestview(view)
  if ("\9" == string.sub(vim.fn.getline("."), 1, 1)) then
    return (wincol - dec(vim.o.tabstop))
  else
    return wincol
  end
end
local function get_fold_edge(lnum, reverse_3f)
  local _17_
  local _18_
  if reverse_3f then
    _18_ = vim.fn.foldclosed
  else
    _18_ = vim.fn.foldclosedend
  end
  _17_ = _18_(lnum)
  if (_17_ == -1) then
    return nil
  elseif (nil ~= _17_) then
    local fold_edge = _17_
    return fold_edge
  end
end
local function maparg_expr(name, mode)
  local rhs = vim.fn.maparg(name, mode)
  local ok_3f, eval_rhs = pcall(vim.fn.eval, rhs)
  if (ok_3f and (type(eval_rhs) == "string")) then
    return eval_rhs
  else
    return rhs
  end
end
local function highlight_range_compat(bufnr, ns, higroup, start, finish, opts)
  if (1 == vim.fn.has("nvim-0.7")) then
    return vim.highlight.range(bufnr, ns, higroup, start, finish, opts)
  else
    return vim.highlight.range(bufnr, ns, higroup, start, finish, opts.regtype, opts.inclusive, opts.priority)
  end
end
local opts
do
  local safe_labels = {"s", "f", "n", "u", "t", "/", "F", "L", "N", "H", "G", "M", "U", "T", "?", "Z"}
  local labels = {"s", "f", "n", "j", "k", "l", "o", "d", "w", "e", "h", "m", "v", "g", "u", "t", "c", ".", "z", "/", "F", "L", "N", "H", "G", "M", "U", "T", "?", "Z"}
  opts = {exit_after_idle_msecs = {labeled = nil, unlabeled = 1000}, force_beacons_into_match_width = false, ignore_case = false, jump_to_unique_chars = {safety_timeout = 400}, labels = labels, limit_ft_matches = 4, match_only_the_start_of_same_char_seqs = true, repeat_ft_with_target_char = false, safe_labels = safe_labels, special_keys = {next_match_group = "<space>", prev_match_group = "<tab>"}, substitute_chars = {["\13"] = "\194\172"}}
end
local removed_opts = {"jump_to_first_match", "instant_repeat_fwd_key", "instant_repeat_bwd_key", "x_mode_prefix_key", "full_inclusive_prefix_key", "grey_out_search_area", "highlight_unique_chars", "jump_on_partial_input_safety_timeout", "cycle_group_fwd_key", "cycle_group_bwd_key"}
local function get_warning_msg(arg_fields)
  local msg = {{"ligthspeed.nvim\n", "Question"}, {"The following fields in the "}, {"opts", "Visual"}, {" table has been renamed or removed:\n\n"}}
  local field_names
  do
    local tbl_12_auto = {}
    for _, field in ipairs(arg_fields) do
      tbl_12_auto[(#tbl_12_auto + 1)] = {("\9" .. field .. "\n")}
    end
    field_names = tbl_12_auto
  end
  local msg_for_jump_to_first_match = {{"The plugin implements \"smart\" auto-jump now, that you can fine-tune via "}, {"opts.labels", "Visual"}, {" and "}, {"opts.safe_labels", "Visual"}, {". See "}, {":h lightspeed-config", "Visual"}, {" for details."}}
  local msg_for_instant_repeat_keys = {{"There are dedicated "}, {"<Plug>", "Visual"}, {" keys available for native-like "}, {";", "Visual"}, {" and "}, {",", "Visual"}, {" functionality now, "}, {"that can also be used for instant repeat only, if you prefer. See "}, {":h lightspeed-custom-mappings", "Visual"}, {"."}}
  local msg_for_x_prefix = {{"Use "}, {"<Plug>Lightspeed_x", "Visual"}, {" and "}, {"<Plug>Lightspeed_X", "Visual"}, {" instead."}}
  local msg_for_grey_out = {{"This flag has been removed. To turn the 'greywash' feature off, "}, {"just set all attributes of the corresponding highlight group to 'none': "}, {":hi LightspeedGreywash guifg=none guibg=none ...", "Visual"}}
  local msg_for_hl_unique_chars = {{"Use "}, {"jump_to_unique_chars", "Visual"}, {" instead. See "}, {":h lightspeed-config", "Visual"}, {" for details."}}
  local msg_for_cycle_keys = {{"Use the "}, {"opts.special_keys", "Visual"}, {" table instead. See "}, {":h lightspeed-config", "Visual"}, {" for details."}}
  local spec_messages = {cycle_group_bwd_key = msg_for_cycle_keys, cycle_group_fwd_key = msg_for_cycle_keys, full_inclusive_prefix_key = msg_for_x_prefix, grey_out_search_area = msg_for_grey_out, highlight_unique_chars = msg_for_hl_unique_chars, instant_repeat_bwd_key = msg_for_instant_repeat_keys, instant_repeat_fwd_key = msg_for_instant_repeat_keys, jump_on_partial_input_safety_timeout = msg_for_hl_unique_chars, jump_to_first_match = msg_for_jump_to_first_match, x_mode_prefix_key = msg_for_x_prefix}
  for _, field_name_chunk in ipairs(field_names) do
    table.insert(msg, field_name_chunk)
  end
  table.insert(msg, {"\n"})
  for field, spec_msg in pairs(spec_messages) do
    if contains_3f(arg_fields, field) then
      table.insert(msg, {(field .. "\n"), "IncSearch"})
      for _, chunk in ipairs(spec_msg) do
        table.insert(msg, chunk)
      end
      table.insert(msg, {"\n\n"})
    end
  end
  return msg
end
do
  local guard
  local function _24_(t, k)
    if contains_3f(removed_opts, k) then
      return api.nvim_echo(get_warning_msg({k}), true, {})
    end
  end
  guard = _24_
  setmetatable(opts, {__index = guard, __newindex = guard})
end
local function normalize_opts(opts0)
  local removed_arg_opts = {}
  for k, v in pairs(opts0) do
    if contains_3f(removed_opts, k) then
      table.insert(removed_arg_opts, k)
      do end (opts0)[k] = nil
    end
  end
  if not empty_3f(removed_arg_opts) then
    api.nvim_echo(get_warning_msg(removed_arg_opts), true, {})
  end
  return opts0
end
local function setup(user_opts)
  opts = setmetatable(normalize_opts(user_opts), {__index = opts})
  return nil
end
local hl
local function _28_(self, _3ftarget_windows)
  if _3ftarget_windows then
    for _, w in ipairs(_3ftarget_windows) do
      api.nvim_buf_clear_namespace(w.bufnr, self.ns, dec(w.topline), w.botline)
    end
  end
  return api.nvim_buf_clear_namespace(0, self.ns, dec(vim.fn.line("w0")), vim.fn.line("w$"))
end
hl = {cleanup = _28_, group = {["label-distant"] = "LightspeedLabelDistant", ["label-distant-overlapped"] = "LightspeedLabelDistantOverlapped", ["label-overlapped"] = "LightspeedLabelOverlapped", ["masked-ch"] = "LightspeedMaskedChar", ["one-char-match"] = "LightspeedOneCharMatch", ["pending-op-area"] = "LightspeedPendingOpArea", ["shortcut-overlapped"] = "LightspeedShortcutOverlapped", ["unique-ch"] = "LightspeedUniqueChar", ["unlabeled-match"] = "LightspeedUnlabeledMatch", cursor = "LightspeedCursor", greywash = "LightspeedGreyWash", label = "LightspeedLabel", shortcut = "LightspeedShortcut"}, ns = api.nvim_create_namespace(""), priority = {cursor = 65535, greywash = 65533, label = 65534}}
local function init_highlight(force_3f)
  local bg = vim.o.background
  local groupdefs
  local _31_
  do
    local _30_ = bg
    if (_30_ == "light") then
      _31_ = "#f02077"
    else
      local _ = _30_
      _31_ = "#ff2f87"
    end
  end
  local _36_
  do
    local _35_ = bg
    if (_35_ == "light") then
      _36_ = "Blue"
    else
      local _ = _35_
      _36_ = "Cyan"
    end
  end
  local _41_
  do
    local _40_ = bg
    if (_40_ == "light") then
      _41_ = "#399d9f"
    else
      local _ = _40_
      _41_ = "#99ddff"
    end
  end
  local _46_
  do
    local _45_ = bg
    if (_45_ == "light") then
      _46_ = "#cc9999"
    else
      local _ = _45_
      _46_ = "#b38080"
    end
  end
  local _51_
  do
    local _50_ = bg
    if (_50_ == "light") then
      _51_ = "Black"
    else
      local _ = _50_
      _51_ = "White"
    end
  end
  local _56_
  do
    local _55_ = bg
    if (_55_ == "light") then
      _56_ = "#272020"
    else
      local _ = _55_
      _56_ = "#f3ecec"
    end
  end
  groupdefs = {[hl.group.greywash] = {cterm = "NONE", ctermbg = "NONE", ctermfg = "Grey", gui = "NONE", guibg = "NONE", guifg = "#777777"}, [hl.group.label] = {cterm = "bold,underline", ctermbg = "NONE", ctermfg = "Red", gui = "bold,underline", guibg = "NONE", guifg = _31_}, [hl.group.shortcut] = {cterm = "bold", ctermbg = "Red", ctermfg = "White", gui = "bold", guibg = "#f00077", guifg = "#ffffff"}, [hl.group["label-distant"]] = {cterm = "bold,underline", ctermbg = "NONE", ctermfg = _36_, gui = "bold,underline", guibg = "NONE", guifg = _41_}, [hl.group["masked-ch"]] = {cterm = "NONE", ctermbg = "NONE", ctermfg = "DarkGrey", gui = "NONE", guibg = "NONE", guifg = _46_}, [hl.group["unlabeled-match"]] = {cterm = "bold", ctermbg = "NONE", ctermfg = _51_, gui = "bold", guibg = "NONE", guifg = _56_}}
  for name, hl_def_map in pairs(groupdefs) do
    local attrs_str
    local _60_
    do
      local tbl_12_auto = {}
      for k, v in pairs(hl_def_map) do
        tbl_12_auto[(#tbl_12_auto + 1)] = (k .. "=" .. v)
      end
      _60_ = tbl_12_auto
    end
    attrs_str = table.concat(_60_, " ")
    local _61_
    if force_3f then
      _61_ = ""
    else
      _61_ = "default "
    end
    vim.cmd(("highlight " .. _61_ .. name .. " " .. attrs_str))
  end
  for from_group, to_group in pairs({[hl.group.cursor] = "Cursor", [hl.group["label-distant-overlapped"]] = hl.group["label-distant"], [hl.group["label-overlapped"]] = hl.group.label, [hl.group["one-char-match"]] = hl.group.shortcut, [hl.group["pending-op-area"]] = "IncSearch", [hl.group["shortcut-overlapped"]] = hl.group.shortcut, [hl.group["unique-ch"]] = hl.group["unlabeled-match"]}) do
    local _63_
    if force_3f then
      _63_ = ""
    else
      _63_ = "default "
    end
    vim.cmd(("highlight! " .. _63_ .. "link " .. from_group .. " " .. to_group))
  end
  return nil
end
local function grey_out_search_area(reverse_3f, _3ftarget_windows, omni_3f)
  if (_3ftarget_windows or omni_3f) then
    for _, win in ipairs((_3ftarget_windows or {vim.fn.getwininfo(vim.fn.win_getid())[1]})) do
      highlight_range_compat(win.bufnr, hl.ns, hl.group.greywash, {dec(win.topline), 0}, {dec(win.botline), -1}, {inclusive = false, priority = hl.priority.greywash, regtype = "v"})
    end
    return nil
  else
    local _let_65_ = map(dec, get_cursor_pos())
    local curline = _let_65_[1]
    local curcol = _let_65_[2]
    local _let_66_ = {dec(vim.fn.line("w0")), dec(vim.fn.line("w$"))}
    local win_top = _let_66_[1]
    local win_bot = _let_66_[2]
    local function _68_()
      if reverse_3f then
        return {{win_top, 0}, {curline, curcol}}
      else
        return {{curline, inc(curcol)}, {win_bot, -1}}
      end
    end
    local _let_67_ = _68_()
    local start = _let_67_[1]
    local finish = _let_67_[2]
    return highlight_range_compat(0, hl.ns, hl.group.greywash, start, finish, {regtype = "v"}, {inclusive = false}, {priority = hl.priority.greywash})
  end
end
local function highlight_range(hl_group, _70_, _72_, _74_)
  local _arg_71_ = _70_
  local startline = _arg_71_[1]
  local startcol = _arg_71_[2]
  local start = _arg_71_
  local _arg_73_ = _72_
  local endline = _arg_73_[1]
  local endcol = _arg_73_[2]
  local _end = _arg_73_
  local _arg_75_ = _74_
  local inclusive_motion_3f = _arg_75_["inclusive-motion?"]
  local motion_force = _arg_75_["motion-force"]
  local hl_range
  local function _76_(start0, _end0, end_inclusive_3f)
    return highlight_range_compat(0, hl.ns, hl_group, start0, _end0, {inclusive = end_inclusive_3f, priority = hl.priority.label, regtype = "v"})
  end
  hl_range = _76_
  local _77_ = motion_force
  if (_77_ == _3cctrl_v_3e) then
    local _let_78_ = {min(startcol, endcol), max(startcol, endcol)}
    local startcol0 = _let_78_[1]
    local endcol0 = _let_78_[2]
    for line = startline, endline do
      hl_range({line, startcol0}, {line, endcol0}, true)
    end
    return nil
  elseif (_77_ == "V") then
    return hl_range({startline, 0}, {endline, -1})
  elseif (_77_ == "v") then
    return hl_range(start, _end, not inclusive_motion_3f)
  elseif (_77_ == nil) then
    return hl_range(start, _end, inclusive_motion_3f)
  end
end
local function echo_no_prev_search()
  return echo("no previous search")
end
local function echo_not_found(s)
  return echo(("not found: " .. s))
end
local function push_cursor_21(direction)
  local function _81_()
    local _80_ = direction
    if (_80_ == "fwd") then
      return "W"
    elseif (_80_ == "bwd") then
      return "bW"
    end
  end
  return vim.fn.search("\\_.", _81_())
end
local function get_restore_virtualedit_autocmd()
  return ("autocmd " .. "CursorMoved,WinLeave,BufLeave,InsertEnter,CmdlineEnter,CmdwinEnter" .. " * ++once set virtualedit=" .. vim.o.virtualedit)
end
local function force_matchparen_refresh()
  vim.cmd("silent! doautocmd matchparen CursorMoved")
  return vim.cmd("silent! doautocmd matchup_matchparen CursorMoved")
end
local function cursor_before_eof_3f()
  return ((vim.fn.line(".") == vim.fn.line("$")) and (vim.fn.virtcol(".") == dec(vim.fn.virtcol("$"))))
end
local function jump_to_21_2a(target, _83_)
  local _arg_84_ = _83_
  local add_to_jumplist_3f = _arg_84_["add-to-jumplist?"]
  local adjust = _arg_84_["adjust"]
  local inclusive_motion_3f = _arg_84_["inclusive-motion?"]
  local mode = _arg_84_["mode"]
  local reverse_3f = _arg_84_["reverse?"]
  local op_mode_3f = string.match(mode, "o")
  local motion_force = get_motion_force(mode)
  local restore_virtualedit_autocmd = get_restore_virtualedit_autocmd()
  if add_to_jumplist_3f then
    vim.cmd("norm! m`")
  end
  vim.fn.cursor(target)
  adjust()
  if not op_mode_3f then
    force_matchparen_refresh()
  end
  local adjusted_pos = get_cursor_pos()
  if (op_mode_3f and not reverse_3f and inclusive_motion_3f) then
    local _87_ = motion_force
    if (_87_ == nil) then
      if not cursor_before_eof_3f() then
        push_cursor_21("fwd")
      else
        vim.cmd("set virtualedit=onemore")
        vim.cmd("norm! l")
        vim.cmd(restore_virtualedit_autocmd)
      end
    elseif (_87_ == "V") then
    elseif (_87_ == _3cctrl_v_3e) then
    elseif (_87_ == "v") then
      push_cursor_21("bwd")
    end
  end
  return adjusted_pos
end
local function get_onscreen_lines(_91_)
  local _arg_92_ = _91_
  local get_full_window_3f = _arg_92_["get-full-window?"]
  local reverse_3f = _arg_92_["reverse?"]
  local skip_folds_3f = _arg_92_["skip-folds?"]
  local lines = {}
  local wintop = vim.fn.line("w0")
  local winbot = vim.fn.line("w$")
  local lnum
  if get_full_window_3f then
    if reverse_3f then
      lnum = winbot
    else
      lnum = wintop
    end
  else
    lnum = vim.fn.line(".")
  end
  while true do
    local _95_
    if reverse_3f then
      _95_ = (lnum >= wintop)
    else
      _95_ = (lnum <= winbot)
    end
    if not _95_ then break end
    local fold_edge = get_fold_edge(lnum, reverse_3f)
    if (skip_folds_3f and fold_edge) then
      local _97_
      if reverse_3f then
        _97_ = dec
      else
        _97_ = inc
      end
      lnum = _97_(fold_edge)
    else
      lines[lnum] = vim.fn.getline(lnum)
      local _99_
      if reverse_3f then
        _99_ = dec
      else
        _99_ = inc
      end
      lnum = _99_(lnum)
    end
  end
  return lines
end
local function get_horizontal_bounds(_102_)
  local _arg_103_ = _102_
  local match_width = _arg_103_["match-width"]
  local textoff = (vim.fn.getwininfo(vim.fn.win_getid())[1].textoff or dec(leftmost_editable_wincol()))
  local offset_in_win = dec(vim.fn.wincol())
  local offset_in_editable_win = (offset_in_win - textoff)
  local left_bound = (vim.fn.virtcol(".") - offset_in_editable_win)
  local window_width = api.nvim_win_get_width(0)
  local right_edge = (left_bound + dec((window_width - textoff)))
  local right_bound = (right_edge - dec(match_width))
  return {left_bound, right_bound}
end
local function onscreen_match_positions(pattern, reverse_3f, _104_)
  local _arg_105_ = _104_
  local cross_window_3f = _arg_105_["cross-window?"]
  local ft_search_3f = _arg_105_["ft-search?"]
  local limit = _arg_105_["limit"]
  local to_eol_3f = _arg_105_["to-eol?"]
  local view = vim.fn.winsaveview()
  local cpo = vim.o.cpo
  local opts0
  if reverse_3f then
    opts0 = "b"
  else
    opts0 = ""
  end
  local wintop = vim.fn.line("w0")
  local winbot = vim.fn.line("w$")
  local stopline
  if reverse_3f then
    stopline = wintop
  else
    stopline = winbot
  end
  local cleanup
  local function _108_()
    vim.fn.winrestview(view)
    vim.o.cpo = cpo
    return nil
  end
  cleanup = _108_
  local _110_
  if ft_search_3f then
    _110_ = 1
  else
    _110_ = 2
  end
  local _let_109_ = get_horizontal_bounds({["match-width"] = _110_})
  local left_bound = _let_109_[1]
  local right_bound = _let_109_[2]
  local function reach_right_bound()
    while ((vim.fn.virtcol(".") < right_bound) and not (vim.fn.col(".") >= dec(vim.fn.col("$")))) do
      vim.cmd("norm! l")
    end
    return nil
  end
  local function skip_to_fold_edge_21()
    local _112_
    local _113_
    if reverse_3f then
      _113_ = vim.fn.foldclosed
    else
      _113_ = vim.fn.foldclosedend
    end
    _112_ = _113_(vim.fn.line("."))
    if (_112_ == -1) then
      return "not-in-fold"
    elseif (nil ~= _112_) then
      local fold_edge = _112_
      vim.fn.cursor(fold_edge, 0)
      local function _115_()
        if reverse_3f then
          return 1
        else
          return vim.fn.col("$")
        end
      end
      vim.fn.cursor(0, _115_())
      return "moved-the-cursor"
    end
  end
  local function skip_to_next_in_window_pos_21()
    local _local_117_ = {vim.fn.line("."), vim.fn.virtcol(".")}
    local line = _local_117_[1]
    local virtcol = _local_117_[2]
    local from_pos = _local_117_
    local _118_
    if (virtcol < left_bound) then
      if reverse_3f then
        if (dec(line) >= stopline) then
          _118_ = {dec(line), right_bound}
        else
        _118_ = nil
        end
      else
        _118_ = {line, left_bound}
      end
    elseif (virtcol > right_bound) then
      if reverse_3f then
        _118_ = {line, right_bound}
      else
        if (inc(line) <= stopline) then
          _118_ = {inc(line), left_bound}
        else
        _118_ = nil
        end
      end
    else
    _118_ = nil
    end
    if (nil ~= _118_) then
      local to_pos = _118_
      if (from_pos ~= to_pos) then
        vim.fn.cursor(to_pos)
        if reverse_3f then
          reach_right_bound()
        end
        return "moved-the-cursor"
      end
    end
  end
  vim.o.cpo = cpo:gsub("c", "")
  local win_enter_3f = nil
  local match_count = 0
  if cross_window_3f then
    win_enter_3f = true
    local function _127_()
      if reverse_3f then
        return {winbot, right_bound}
      else
        return {wintop, left_bound}
      end
    end
    vim.fn.cursor(_127_())
    if reverse_3f then
      reach_right_bound()
    end
  end
  local function recur(match_at_curpos_3f)
    local match_at_curpos_3f0
    local function _130_()
      if win_enter_3f then
        win_enter_3f = false
        return true
      end
    end
    match_at_curpos_3f0 = (match_at_curpos_3f or _130_())
    if (limit and (match_count >= limit)) then
      return cleanup()
    else
      local _131_
      local _132_
      if match_at_curpos_3f0 then
        _132_ = "c"
      else
        _132_ = ""
      end
      _131_ = vim.fn.searchpos(pattern, (opts0 .. _132_), stopline)
      if ((type(_131_) == "table") and ((_131_)[1] == 0) and true) then
        local _ = (_131_)[2]
        return cleanup()
      elseif ((type(_131_) == "table") and (nil ~= (_131_)[1]) and (nil ~= (_131_)[2])) then
        local line = (_131_)[1]
        local col = (_131_)[2]
        local pos = _131_
        if ft_search_3f then
          match_count = (match_count + 1)
          return pos
        else
          local _134_ = skip_to_fold_edge_21()
          if (_134_ == "moved-the-cursor") then
            return recur(false)
          elseif (_134_ == "not-in-fold") then
            if (vim.wo.wrap or (function(_135_,_136_,_137_) return (_135_ <= _136_) and (_136_ <= _137_) end)(left_bound,col,right_bound) or to_eol_3f) then
              match_count = (match_count + 1)
              return {line, col, left_bound, right_bound}
            else
              local _138_ = skip_to_next_in_window_pos_21()
              if (_138_ == "moved-the-cursor") then
                return recur(true)
              else
                local _ = _138_
                return cleanup()
              end
            end
          end
        end
      end
    end
  end
  return recur
end
local function highlight_cursor(_3fpos)
  local _let_145_ = (_3fpos or get_cursor_pos())
  local line = _let_145_[1]
  local col = _let_145_[2]
  local pos = _let_145_
  local ch_at_curpos = (char_at_pos(pos, {}) or " ")
  return api.nvim_buf_set_extmark(0, hl.ns, dec(line), dec(col), {hl_mode = "combine", priority = hl.priority.cursor, virt_text = {{ch_at_curpos, hl.group.cursor}}, virt_text_pos = "overlay"})
end
local function handle_interrupted_change_op_21()
  echo("")
  local curcol = vim.fn.col(".")
  local endcol = vim.fn.col("$")
  local _3fright
  if (not vim.o.insertmode and (curcol > 1) and (curcol < endcol)) then
    _3fright = "<RIGHT>"
  else
    _3fright = ""
  end
  return api.nvim_feedkeys(replace_keycodes(("<C-\\><C-G>" .. _3fright)), "n", true)
end
local function doau_when_exists(event)
  if vim.fn.exists(("#User#" .. event)) then
    return vim.cmd(("doautocmd <nomodeline> User " .. event))
  end
end
local function enter(mode)
  doau_when_exists("LightspeedEnter")
  local _148_ = mode
  if (_148_ == "ft") then
    return doau_when_exists("LightspeedFtEnter")
  elseif (_148_ == "sx") then
    return doau_when_exists("LightspeedSxEnter")
  end
end
local function get_input(_3ftimeout)
  local esc_keycode = 27
  local char_available_3f
  local function _150_()
    return (0 ~= vim.fn.getchar(1))
  end
  char_available_3f = _150_
  local getchar_timeout
  local function _151_()
    if vim.wait(_3ftimeout, char_available_3f, 100) then
      return vim.fn.getchar(0)
    end
  end
  getchar_timeout = _151_
  local ok_3f, ch = nil, nil
  local function _153_()
    if _3ftimeout then
      return getchar_timeout
    else
      return vim.fn.getchar
    end
  end
  ok_3f, ch = pcall(_153_())
  if (ok_3f and (ch ~= esc_keycode)) then
    if (type(ch) == "number") then
      return vim.fn.nr2char(ch)
    else
      return ch
    end
  end
end
local function set_dot_repeat(cmd, _3fcount)
  local op = vim.v.operator
  local change
  if (op == "c") then
    change = replace_keycodes("<c-r>.<esc>")
  else
  change = nil
  end
  local seq = (op .. (_3fcount or "") .. cmd .. (change or ""))
  pcall(vim.fn["repeat#setreg"], seq, vim.v.register)
  return pcall(vim.fn["repeat#set"], seq, -1)
end
local function get_plug_key(search_mode, reverse_3f, x_2ft_3f, repeat_invoc)
  local _158_
  do
    local _157_ = repeat_invoc
    if (_157_ == "dot") then
      _158_ = "dotrepeat_"
    else
      local _ = _157_
      _158_ = ""
    end
  end
  local _163_
  do
    local _162_ = {search_mode, not not reverse_3f, not not x_2ft_3f}
    if ((type(_162_) == "table") and ((_162_)[1] == "ft") and ((_162_)[2] == false) and ((_162_)[3] == false)) then
      _163_ = "f"
    elseif ((type(_162_) == "table") and ((_162_)[1] == "ft") and ((_162_)[2] == true) and ((_162_)[3] == false)) then
      _163_ = "F"
    elseif ((type(_162_) == "table") and ((_162_)[1] == "ft") and ((_162_)[2] == false) and ((_162_)[3] == true)) then
      _163_ = "t"
    elseif ((type(_162_) == "table") and ((_162_)[1] == "ft") and ((_162_)[2] == true) and ((_162_)[3] == true)) then
      _163_ = "T"
    elseif ((type(_162_) == "table") and ((_162_)[1] == "sx") and ((_162_)[2] == false) and ((_162_)[3] == false)) then
      _163_ = "s"
    elseif ((type(_162_) == "table") and ((_162_)[1] == "sx") and ((_162_)[2] == true) and ((_162_)[3] == false)) then
      _163_ = "S"
    elseif ((type(_162_) == "table") and ((_162_)[1] == "sx") and ((_162_)[2] == false) and ((_162_)[3] == true)) then
      _163_ = "x"
    elseif ((type(_162_) == "table") and ((_162_)[1] == "sx") and ((_162_)[2] == true) and ((_162_)[3] == true)) then
      _163_ = "X"
    else
    _163_ = nil
    end
  end
  return ("<Plug>Lightspeed_" .. _158_ .. _163_)
end
local function get_repeat_action(_in, search_mode, x_2ft_3f, instant_repeat_3f, from_reverse_cold_repeat_3f, _3ftarget_char)
  local mode
  if (vim.fn.mode() == "n") then
    mode = "n"
  else
    mode = "x"
  end
  local in_mapped_to = maparg_expr(_in, mode)
  local repeat_plug_key = ("<Plug>Lightspeed_;_" .. search_mode)
  local revert_plug_key = ("<Plug>Lightspeed_,_" .. search_mode)
  local _174_
  if from_reverse_cold_repeat_3f then
    _174_ = revert_plug_key
  else
    _174_ = repeat_plug_key
  end
  if ((_in == _3cbackspace_3e) or ((search_mode == "ft") and opts.repeat_ft_with_target_char and (_in == _3ftarget_char)) or ((in_mapped_to == get_plug_key(search_mode, false, x_2ft_3f)) or (in_mapped_to == _174_))) then
    return "repeat"
  else
    local _176_
    if from_reverse_cold_repeat_3f then
      _176_ = repeat_plug_key
    else
      _176_ = revert_plug_key
    end
    if (instant_repeat_3f and ((_in == "\9") or ((in_mapped_to == get_plug_key(search_mode, true, x_2ft_3f)) or (in_mapped_to == _176_)))) then
      return "revert"
    end
  end
end
local ft = {state = {cold = {["in"] = nil, ["reverse?"] = nil, ["t-mode?"] = nil}, dot = {["in"] = nil}}}
ft.go = function(self, reverse_3f, t_mode_3f, repeat_invoc)
  local mode = api.nvim_get_mode().mode
  local op_mode_3f = mode:match("o")
  local dot_repeatable_op_3f = (op_mode_3f and (vim.v.operator ~= "y"))
  local instant_repeat_3f = (type(repeat_invoc) == "table")
  local instant_state
  if instant_repeat_3f then
    instant_state = repeat_invoc
  else
  instant_state = nil
  end
  local reverted_instant_repeat_3f
  do
    local t_180_ = instant_state
    if (nil ~= t_180_) then
      t_180_ = (t_180_)["reverted?"]
    end
    reverted_instant_repeat_3f = t_180_
  end
  local cold_repeat_3f = (repeat_invoc == "cold")
  local dot_repeat_3f = (repeat_invoc == "dot")
  local invoked_as_reverse_3f = reverse_3f
  local reverse_3f0
  if cold_repeat_3f then
    local function _182_(_241)
      if invoked_as_reverse_3f then
        return not _241
      else
        return _241
      end
    end
    reverse_3f0 = _182_(self.state.cold["reverse?"])
  else
    reverse_3f0 = reverse_3f
  end
  local t_mode_3f0
  if cold_repeat_3f then
    t_mode_3f0 = self.state.cold["t-mode?"]
  else
    t_mode_3f0 = t_mode_3f
  end
  local count
  if reverted_instant_repeat_3f then
    count = 0
  else
    count = vim.v.count1
  end
  local count0
  if (instant_repeat_3f and t_mode_3f0) then
    count0 = inc(count)
  else
    count0 = count
  end
  local function get_num_of_matches_to_be_highlighted()
    local _188_ = opts.limit_ft_matches
    local function _189_()
      local group_limit = _188_
      return (group_limit > 0)
    end
    if ((nil ~= _188_) and _189_()) then
      local group_limit = _188_
      local matches_left_behind
      local function _191_()
        local _190_ = instant_state
        if _190_ then
          local _192_ = (_190_).stack
          if _192_ then
            return #_192_
          else
            return _192_
          end
        else
          return _190_
        end
      end
      matches_left_behind = (_191_() or 0)
      local eaten_up = (matches_left_behind % group_limit)
      local remaining = (group_limit - eaten_up)
      if (remaining == 0) then
        return group_limit
      else
        return remaining
      end
    else
      local _ = _188_
      return 0
    end
  end
  if not instant_repeat_3f then
    enter("ft")
  end
  if not repeat_invoc then
    echo("")
    highlight_cursor()
    vim.cmd("redraw")
  end
  local _199_
  if instant_repeat_3f then
    _199_ = instant_state["in"]
  elseif dot_repeat_3f then
    _199_ = self.state.dot["in"]
  elseif cold_repeat_3f then
    _199_ = self.state.cold["in"]
  else
    local _200_
    local function _201_()
      local res_2_auto
      do
        res_2_auto = get_input()
      end
      hl:cleanup()
      return res_2_auto
    end
    local function _202_()
      if change_operation_3f() then
        handle_interrupted_change_op_21()
      end
      do
      end
      doau_when_exists("LightspeedFtLeave")
      doau_when_exists("LightspeedLeave")
      return nil
    end
    _200_ = (_201_() or _202_())
    if (_200_ == _3cbackspace_3e) then
      local function _204_()
        if change_operation_3f() then
          handle_interrupted_change_op_21()
        end
        do
          echo_no_prev_search()
        end
        doau_when_exists("LightspeedFtLeave")
        doau_when_exists("LightspeedLeave")
        return nil
      end
      _199_ = (self.state.cold["in"] or _204_())
    elseif (nil ~= _200_) then
      local _in = _200_
      _199_ = _in
    else
    _199_ = nil
    end
  end
  if (nil ~= _199_) then
    local in1 = _199_
    local to_eol_3f = (in1 == "\13")
    if not repeat_invoc then
      self.state.cold = {["in"] = in1, ["reverse?"] = reverse_3f0, ["t-mode?"] = t_mode_3f0}
    end
    local jump_pos = nil
    local match_count = 0
    do
      local next_pos
      local function _209_()
        if reverse_3f0 then
          return "nWb"
        else
          return "nW"
        end
      end
      next_pos = vim.fn.searchpos("\\_.", _209_())
      local pattern
      if to_eol_3f then
        pattern = "\\n"
      else
        local _210_
        if opts.ignore_case then
          _210_ = "\\c"
        else
          _210_ = "\\C"
        end
        pattern = ("\\V" .. _210_ .. in1:gsub("\\", "\\\\"))
      end
      local limit = (count0 + get_num_of_matches_to_be_highlighted())
      for _213_ in onscreen_match_positions(pattern, reverse_3f0, {["ft-search?"] = true, limit = limit}) do
        local _each_214_ = _213_
        local line = _each_214_[1]
        local col = _each_214_[2]
        local pos = _each_214_
        if not ((match_count == 0) and cold_repeat_3f and t_mode_3f0 and same_pos_3f(pos, next_pos)) then
          if (match_count <= dec(count0)) then
            jump_pos = pos
          else
            if not op_mode_3f then
              local ch = (char_at_pos(pos, {}) or "\13")
              local ch0
              local function _216_()
                local t_215_ = opts.substitute_chars
                if (nil ~= t_215_) then
                  t_215_ = (t_215_)[ch]
                end
                return t_215_
              end
              ch0 = (_216_() or ch)
              api.nvim_buf_set_extmark(0, hl.ns, dec(line), dec(col), {priority = hl.priority.label, virt_text = {{ch0, hl.group["one-char-match"]}}, virt_text_pos = "overlay"})
            end
          end
          match_count = (match_count + 1)
        end
      end
    end
    if (not reverted_instant_repeat_3f and ((match_count == 0) or ((match_count == 1) and instant_repeat_3f and t_mode_3f0))) then
      if change_operation_3f() then
        handle_interrupted_change_op_21()
      end
      do
        echo_not_found(in1)
      end
      doau_when_exists("LightspeedFtLeave")
      doau_when_exists("LightspeedLeave")
      return nil
    else
      if not reverted_instant_repeat_3f then
        local function _222_()
          if t_mode_3f0 then
            local function _223_()
              if reverse_3f0 then
                return "fwd"
              else
                return "bwd"
              end
            end
            push_cursor_21(_223_())
            if (to_eol_3f and not reverse_3f0 and mode:match("n")) then
              return push_cursor_21("fwd")
            end
          end
        end
        jump_to_21_2a(jump_pos, {["add-to-jumplist?"] = not instant_repeat_3f, ["inclusive-motion?"] = true, ["reverse?"] = reverse_3f0, adjust = _222_, mode = mode})
      end
      if op_mode_3f then
        do
          if dot_repeatable_op_3f then
            self.state.dot = {["in"] = in1}
            set_dot_repeat(replace_keycodes(get_plug_key("ft", reverse_3f0, t_mode_3f0, "dot")), count0)
          end
        end
        doau_when_exists("LightspeedFtLeave")
        doau_when_exists("LightspeedLeave")
        return nil
      else
        highlight_cursor()
        vim.cmd("redraw")
        local _228_
        local function _229_()
          local res_2_auto
          do
            res_2_auto = get_input(opts.exit_after_idle_msecs.unlabeled)
          end
          hl:cleanup()
          return res_2_auto
        end
        local function _230_()
          do
          end
          doau_when_exists("LightspeedFtLeave")
          doau_when_exists("LightspeedLeave")
          return nil
        end
        _228_ = (_229_() or _230_())
        if (nil ~= _228_) then
          local in2 = _228_
          local stack
          local function _232_()
            local t_231_ = instant_state
            if (nil ~= t_231_) then
              t_231_ = (t_231_).stack
            end
            return t_231_
          end
          stack = (_232_() or {})
          local from_reverse_cold_repeat_3f
          if instant_repeat_3f then
            from_reverse_cold_repeat_3f = instant_state["from-reverse-cold-repeat?"]
          else
            from_reverse_cold_repeat_3f = (cold_repeat_3f and invoked_as_reverse_3f)
          end
          local _235_ = get_repeat_action(in2, "ft", t_mode_3f0, instant_repeat_3f, from_reverse_cold_repeat_3f, in1)
          if (_235_ == "repeat") then
            table.insert(stack, get_cursor_pos())
            return ft:go(reverse_3f0, t_mode_3f0, {["from-reverse-cold-repeat?"] = from_reverse_cold_repeat_3f, ["in"] = in1, ["reverted?"] = false, stack = stack})
          elseif (_235_ == "revert") then
            do
              local _236_ = table.remove(stack)
              if _236_ then
                vim.fn.cursor(_236_)
              else
              end
            end
            return ft:go(reverse_3f0, t_mode_3f0, {["from-reverse-cold-repeat?"] = from_reverse_cold_repeat_3f, ["in"] = in1, ["reverted?"] = true, stack = stack})
          else
            local _ = _235_
            do
              vim.fn.feedkeys(in2, "i")
            end
            doau_when_exists("LightspeedFtLeave")
            doau_when_exists("LightspeedLeave")
            return nil
          end
        end
      end
    end
  end
end
local function user_forced_autojump_3f()
  return (not opts.labels or empty_3f(opts.labels))
end
local function user_forced_no_autojump_3f()
  return (not opts.safe_labels or empty_3f(opts.safe_labels))
end
local function get_targetable_windows(reverse_3f, omni_3f)
  local curr_win_id = vim.fn.win_getid()
  local _let_243_ = vim.split(vim.fn.string(vim.fn.winlayout()), tostring(curr_win_id))
  local left = _let_243_[1]
  local right = _let_243_[2]
  local ids
  local _244_
  if omni_3f then
    _244_ = (left .. right)
  elseif reverse_3f then
    _244_ = left
  else
    _244_ = right
  end
  ids = string.gmatch(_244_, "%d+")
  local visual_or_OP_mode_3f = (vim.fn.mode() ~= "n")
  local buf = api.nvim_win_get_buf
  local ids0
  do
    local tbl_12_auto = {}
    for id in ids do
      local _246_
      if not (visual_or_OP_mode_3f and (buf(id) ~= buf(curr_win_id))) then
        _246_ = id
      else
      _246_ = nil
      end
      tbl_12_auto[(#tbl_12_auto + 1)] = _246_
    end
    ids0 = tbl_12_auto
  end
  local ids1
  if reverse_3f then
    ids1 = vim.fn.reverse(ids0)
  else
    ids1 = ids0
  end
  local function _249_(_241)
    return (vim.fn.getwininfo(_241))[1]
  end
  return map(_249_, ids1)
end
local function highlight_unique_chars(reverse_3f, _3ftarget_windows, omni_3f)
  local unique_chars = {}
  local curr_w = vim.fn.getwininfo(vim.fn.win_getid())[1]
  local _let_250_ = get_cursor_pos()
  local curline = _let_250_[1]
  local curcol = _let_250_[2]
  for _, w in ipairs((_3ftarget_windows or {curr_w})) do
    if _3ftarget_windows then
      api.nvim_set_current_win(w.winid)
    end
    local _let_252_ = get_horizontal_bounds({["match-width"] = 2})
    local left_bound = _let_252_[1]
    local right_bound = _let_252_[2]
    local lines = get_onscreen_lines({["get-full-window?"] = (_3ftarget_windows or omni_3f), ["reverse?"] = reverse_3f, ["skip-folds?"] = true})
    for lnum, line in pairs(lines) do
      local startcol
      if ((lnum == curline) and not reverse_3f and not _3ftarget_windows) then
        startcol = inc(curcol)
      else
        startcol = 1
      end
      local endcol
      if ((lnum == curline) and reverse_3f and not _3ftarget_windows) then
        endcol = dec(curcol)
      else
        endcol = #line
      end
      for col = startcol, endcol do
        if (vim.wo.wrap or ((col >= left_bound) and (col <= right_bound))) then
          local ch = line:sub(col, col)
          local ch0
          if opts.ignore_case then
            ch0 = ch:lower()
          else
            ch0 = ch
          end
          local _257_
          do
            local _256_ = unique_chars[ch0]
            if (nil ~= _256_) then
              local pos_already_there = _256_
              _257_ = false
            else
              local _0 = _256_
              _257_ = {lnum, col, w}
            end
          end
          unique_chars[ch0] = _257_
        end
      end
    end
  end
  if _3ftarget_windows then
    api.nvim_set_current_win(curr_w.winid)
  end
  for ch, pos in pairs(unique_chars) do
    local _263_ = pos
    if ((type(_263_) == "table") and (nil ~= (_263_)[1]) and (nil ~= (_263_)[2]) and (nil ~= (_263_)[3])) then
      local lnum = (_263_)[1]
      local col = (_263_)[2]
      local w = (_263_)[3]
      api.nvim_buf_add_highlight(w.bufnr, hl.ns, hl.group["unique-ch"], dec(lnum), dec(col), col)
    end
  end
  return nil
end
local function get_targets_2a(input, reverse_3f, _3fwininfo, _3ftargets)
  local targets = (_3ftargets or {})
  local to_eol_3f = (input == "\13")
  local winid = vim.fn.win_getid()
  local prev_match = {}
  local added_prev_match_3f = nil
  local pattern
  if to_eol_3f then
    pattern = "\\n"
  else
    local _265_
    if opts.ignore_case then
      _265_ = "\\c"
    else
      _265_ = "\\C"
    end
    pattern = ("\\V" .. _265_ .. input:gsub("\\", "\\\\") .. "\\_.")
  end
  for _268_ in onscreen_match_positions(pattern, reverse_3f, {["cross-window?"] = _3fwininfo, ["to-eol?"] = to_eol_3f}) do
    local _each_269_ = _268_
    local line = _each_269_[1]
    local col = _each_269_[2]
    local pos = _each_269_
    local target = {pos = pos, wininfo = _3fwininfo}
    if to_eol_3f then
      target["pair"] = {"\n", ""}
      table.insert(targets, target)
    else
      local ch1 = char_at_pos(pos, {})
      local ch2 = (char_at_pos(pos, {["char-offset"] = 1}) or "\13")
      local to_pre_eol_3f = (ch2 == "\13")
      local overlaps_prev_match_3f
      local _270_
      if reverse_3f then
        _270_ = dec
      else
        _270_ = inc
      end
      overlaps_prev_match_3f = ((line == prev_match.line) and (col == _270_(prev_match.col)))
      local same_char_triplet_3f = (overlaps_prev_match_3f and (ch2 == prev_match.ch2))
      local overlaps_prev_target_3f = (overlaps_prev_match_3f and added_prev_match_3f)
      prev_match = {ch2 = ch2, col = col, line = line}
      if (same_char_triplet_3f and (added_prev_match_3f or opts.match_only_the_start_of_same_char_seqs)) then
        added_prev_match_3f = false
      else
        local _
        target["pair"] = {ch1, ch2}
        _ = nil
        local prev_target = last(targets)
        local min_delta_to_prevent_squeezing = 4
        local close_to_prev_target_3f
        do
          local _272_ = prev_target
          if ((type(_272_) == "table") and ((type((_272_).pos) == "table") and (nil ~= ((_272_).pos)[1]) and (nil ~= ((_272_).pos)[2]))) then
            local prev_line = ((_272_).pos)[1]
            local prev_col = ((_272_).pos)[2]
            local function _274_()
              local col_delta
              if reverse_3f then
                col_delta = (prev_col - col)
              else
                col_delta = (col - prev_col)
              end
              return (col_delta < min_delta_to_prevent_squeezing)
            end
            close_to_prev_target_3f = ((line == prev_line) and _274_())
          else
          close_to_prev_target_3f = nil
          end
        end
        if to_pre_eol_3f then
          target["squeezed?"] = true
        end
        if close_to_prev_target_3f then
          local _277_
          if reverse_3f then
            _277_ = target
          else
            _277_ = prev_target
          end
          _277_["squeezed?"] = true
        end
        if overlaps_prev_target_3f then
          local _280_
          if reverse_3f then
            _280_ = prev_target
          else
            _280_ = target
          end
          _280_["overlapped?"] = true
        end
        table.insert(targets, target)
        added_prev_match_3f = true
      end
    end
  end
  if next(targets) then
    return targets
  end
end
local function distance(_286_, _288_, vertical_only_3f)
  local _arg_287_ = _286_
  local line1 = _arg_287_[1]
  local col1 = _arg_287_[2]
  local _arg_289_ = _288_
  local line2 = _arg_289_[1]
  local col2 = _arg_289_[2]
  local editor_grid_aspect_ratio = 0.3
  local _let_290_ = {abs((col1 - col2)), abs((line1 - line2))}
  local dx = _let_290_[1]
  local dy = _let_290_[2]
  local dx0
  local _291_
  if vertical_only_3f then
    _291_ = 0
  else
    _291_ = 1
  end
  dx0 = (dx * editor_grid_aspect_ratio * _291_)
  return pow((pow(dx0, 2) + pow(dy, 2)), 0.5)
end
local function get_targets(input, reverse_3f, _3ftarget_windows, omni_3f)
  local to_eol_3f = (input == "\13")
  local function calculate_screen_positions_3f(targets)
    return (vim.wo.wrap and (#targets < 200))
  end
  if _3ftarget_windows then
    local curr_w = vim.fn.getwininfo(vim.fn.win_getid())[1]
    local cursor_positions = {}
    local targets = {}
    for _, w in ipairs(_3ftarget_windows) do
      api.nvim_set_current_win(w.winid)
      do end (cursor_positions)[w.winid] = get_cursor_pos()
      get_targets_2a(input, reverse_3f, w, targets)
    end
    api.nvim_set_current_win(curr_w.winid)
    if next(targets) then
      if omni_3f then
        local calculate_screen_positions_3f0 = calculate_screen_positions_3f(targets)
        if calculate_screen_positions_3f0 then
          for winid, _293_ in pairs(cursor_positions) do
            local _each_294_ = _293_
            local line = _each_294_[1]
            local col = _each_294_[2]
            local screenpos = vim.fn.screenpos(winid, line, col)
            do end (cursor_positions)[winid] = {screenpos.row, screenpos.col}
          end
        end
        for _, _296_ in ipairs(targets) do
          local _each_297_ = _296_
          local t = _each_297_
          local _each_298_ = _each_297_["pos"]
          local line = _each_298_[1]
          local col = _each_298_[2]
          local _each_299_ = _each_297_["wininfo"]
          local winid = _each_299_["winid"]
          if calculate_screen_positions_3f0 then
            local screenpos = vim.fn.screenpos(winid, line, col)
            do end (t)["screenpos"] = {screenpos.row, screenpos.col}
          end
          local cursor_pos = cursor_positions[winid]
          local pos = (t.screenpos or t.pos)
          do end (t)["rank"] = distance(pos, cursor_pos, to_eol_3f)
        end
        local function _301_(_241, _242)
          return ((_241).rank < (_242).rank)
        end
        table.sort(targets, _301_)
      end
      return targets
    end
  elseif omni_3f then
    local _304_ = get_targets_2a(input, true, nil, get_targets_2a(input, false))
    if (nil ~= _304_) then
      local targets = _304_
      local winid = vim.fn.win_getid()
      local calculate_screen_positions_3f0 = calculate_screen_positions_3f(targets)
      local _let_305_ = get_cursor_pos()
      local curline = _let_305_[1]
      local curcol = _let_305_[2]
      local curpos = _let_305_
      local curscreenpos = vim.fn.screenpos(winid, curline, curcol)
      local cursor_pos
      if calculate_screen_positions_3f0 then
        cursor_pos = {curscreenpos.row, curscreenpos.col}
      else
        cursor_pos = curpos
      end
      for _, _307_ in ipairs(targets) do
        local _each_308_ = _307_
        local t = _each_308_
        local _each_309_ = _each_308_["pos"]
        local line = _each_309_[1]
        local col = _each_309_[2]
        if calculate_screen_positions_3f0 then
          local screenpos = vim.fn.screenpos(winid, line, col)
          do end (t)["screenpos"] = {screenpos.row, screenpos.col}
        end
        local pos = (t.screenpos or t.pos)
        do end (t)["rank"] = distance(pos, cursor_pos, to_eol_3f)
      end
      local function _311_(_241, _242)
        return ((_241).rank < (_242).rank)
      end
      table.sort(targets, _311_)
      return targets
    end
  else
    return get_targets_2a(input, reverse_3f)
  end
end
local function populate_sublists(targets)
  targets["sublists"] = {}
  if opts.ignore_case then
    local function _314_(self, k)
      return rawget(self, k:lower())
    end
    local function _315_(self, k, v)
      return rawset(self, k:lower(), v)
    end
    setmetatable(targets.sublists, {__index = _314_, __newindex = _315_})
  end
  for _, _317_ in ipairs(targets) do
    local _each_318_ = _317_
    local target = _each_318_
    local _each_319_ = _each_318_["pair"]
    local _0 = _each_319_[1]
    local ch2 = _each_319_[2]
    if not targets.sublists[ch2] then
      targets["sublists"][ch2] = {}
    end
    table.insert(targets.sublists[ch2], target)
  end
  return nil
end
local function set_autojump(sublist, to_eol_3f)
  sublist["autojump?"] = (not (user_forced_no_autojump_3f() or to_eol_3f or operator_pending_mode_3f()) and (user_forced_autojump_3f() or (#opts.safe_labels >= dec(#sublist))))
  return nil
end
local function attach_label_set(sublist)
  local _321_
  if user_forced_autojump_3f() then
    _321_ = opts.safe_labels
  elseif user_forced_no_autojump_3f() then
    _321_ = opts.labels
  elseif sublist["autojump?"] then
    _321_ = opts.safe_labels
  else
    _321_ = opts.labels
  end
  sublist["label-set"] = _321_
  return nil
end
local function set_sublist_attributes(targets, to_eol_3f)
  for _, sublist in pairs(targets.sublists) do
    set_autojump(sublist, to_eol_3f)
    attach_label_set(sublist)
  end
  return nil
end
local function set_labels(targets, to_eol_3f)
  for _, sublist in pairs(targets.sublists) do
    if (#sublist > 1) then
      local autojump_3f = sublist["autojump?"]
      local labels = sublist["label-set"]
      for i, target in ipairs(sublist) do
        local _323_
        if not (autojump_3f and (i == 1)) then
          local _324_
          local _326_
          if autojump_3f then
            _326_ = dec(i)
          else
            _326_ = i
          end
          _324_ = (_326_ % #labels)
          if (_324_ == 0) then
            _323_ = last(labels)
          elseif (nil ~= _324_) then
            local n = _324_
            _323_ = labels[n]
          else
          _323_ = nil
          end
        else
        _323_ = nil
        end
        target["label"] = _323_
      end
    end
  end
  return nil
end
local function set_label_states(sublist, _333_)
  local _arg_334_ = _333_
  local group_offset = _arg_334_["group-offset"]
  local labels = sublist["label-set"]
  local _7clabels_7c = #labels
  local offset = (group_offset * _7clabels_7c)
  local primary_start
  local _335_
  if sublist["autojump?"] then
    _335_ = 2
  else
    _335_ = 1
  end
  primary_start = (offset + _335_)
  local primary_end = (primary_start + dec(_7clabels_7c))
  local secondary_end = (primary_end + _7clabels_7c)
  for i, target in ipairs(sublist) do
    if target.label then
      local _337_
      if ((i < primary_start) or (i > secondary_end)) then
        _337_ = "inactive"
      elseif (i <= primary_end) then
        _337_ = "active-primary"
      else
        _337_ = "active-secondary"
      end
      target["label-state"] = _337_
    end
  end
  return nil
end
local function set_initial_label_states(targets)
  for _, sublist in pairs(targets.sublists) do
    set_label_states(sublist, {["group-offset"] = 0})
  end
  return nil
end
local function set_shortcuts_and_populate_shortcuts_map(targets)
  targets["shortcuts"] = {}
  local potential_2nd_inputs
  do
    local tbl_9_auto = {}
    for ch2, _ in pairs(targets.sublists) do
      local _340_, _341_ = ch2, true
      if ((nil ~= _340_) and (nil ~= _341_)) then
        local k_10_auto = _340_
        local v_11_auto = _341_
        tbl_9_auto[k_10_auto] = v_11_auto
      end
    end
    potential_2nd_inputs = tbl_9_auto
  end
  local labels_used_up_as_shortcut = {}
  for _, _343_ in ipairs(targets) do
    local _each_344_ = _343_
    local target = _each_344_
    local label = _each_344_["label"]
    local label_state = _each_344_["label-state"]
    if (label_state == "active-primary") then
      if not ((potential_2nd_inputs)[label] or labels_used_up_as_shortcut[label]) then
        target["shortcut?"] = true
        targets.shortcuts[label] = target
        labels_used_up_as_shortcut[label] = true
      end
    end
  end
  return nil
end
local function set_beacon(_347_, _repeat)
  local _arg_348_ = _347_
  local target = _arg_348_
  local label = _arg_348_["label"]
  local label_state = _arg_348_["label-state"]
  local overlapped_3f = _arg_348_["overlapped?"]
  local _arg_349_ = _arg_348_["pair"]
  local ch1 = _arg_349_[1]
  local ch2 = _arg_349_[2]
  local _arg_350_ = _arg_348_["pos"]
  local _ = _arg_350_[1]
  local col = _arg_350_[2]
  local left_bound = _arg_350_[3]
  local right_bound = _arg_350_[4]
  local shortcut_3f = _arg_348_["shortcut?"]
  local squeezed_3f = _arg_348_["squeezed?"]
  local to_eol_3f = ((ch1 == "\n") and (ch2 == ""))
  local ch10
  if to_eol_3f then
    ch10 = "\13"
  else
    ch10 = ch1
  end
  local function _353_(_241)
    local function _355_()
      local t_354_ = opts.substitute_chars
      if (nil ~= t_354_) then
        t_354_ = (t_354_)[_241]
      end
      return t_354_
    end
    return (_355_() or _241)
  end
  local _let_352_ = map(_353_, {ch10, ch2})
  local ch11 = _let_352_[1]
  local ch20 = _let_352_[2]
  local squeezed_3f0 = (opts.force_beacons_into_match_width or squeezed_3f)
  local onscreen_3f = (vim.wo.wrap or ((col <= right_bound) and (col >= left_bound)))
  local left_off_3f = (col < left_bound)
  local right_off_3f = (col > right_bound)
  local hg = hl.group
  local masked_char_24 = {ch20, hg["masked-ch"]}
  local label_24 = {label, hg.label}
  local shortcut_24 = {label, hg.shortcut}
  local distant_label_24 = {label, hg["label-distant"]}
  local overlapped_label_24 = {label, hg["label-overlapped"]}
  local overlapped_shortcut_24 = {label, hg["shortcut-overlapped"]}
  local overlapped_distant_label_24 = {label, hg["label-distant-overlapped"]}
  if (_repeat == "instant-unsafe") then
    target.beacon = {0, {{(ch11 .. ch20), hg["one-char-match"]}}}
  else
    local _357_ = label_state
    if (_357_ == nil) then
      if not (_repeat or to_eol_3f) then
        if overlapped_3f then
          target.beacon = {1, {{ch20, hg["unlabeled-match"]}}}
        else
          target.beacon = {0, {{(ch11 .. ch20), hg["unlabeled-match"]}}}
        end
      else
      target.beacon = nil
      end
    elseif (_357_ == "active-primary") then
      if to_eol_3f then
        if onscreen_3f then
          target.beacon = {0, {shortcut_24}}
        elseif left_off_3f then
          target.beacon = {0, {{"<", hg["one-char-match"]}, shortcut_24}, "left-off"}
        elseif right_off_3f then
          target.beacon = {dec((right_bound - col)), {shortcut_24, {">", hg["one-char-match"]}}}
        else
        target.beacon = nil
        end
      elseif _repeat then
        local _361_
        if squeezed_3f0 then
          _361_ = 1
        else
          _361_ = 2
        end
        target.beacon = {_361_, {shortcut_24}}
      elseif shortcut_3f then
        if overlapped_3f then
          target.beacon = {1, {overlapped_shortcut_24}}
        else
          if squeezed_3f0 then
            target.beacon = {0, {masked_char_24, shortcut_24}}
          else
            target.beacon = {2, {shortcut_24}}
          end
        end
      elseif overlapped_3f then
        target.beacon = {1, {overlapped_label_24}}
      elseif squeezed_3f0 then
        target.beacon = {0, {masked_char_24, label_24}}
      else
        target.beacon = {2, {label_24}}
      end
    elseif (_357_ == "active-secondary") then
      if to_eol_3f then
        if onscreen_3f then
          target.beacon = {0, {distant_label_24}}
        elseif left_off_3f then
          target.beacon = {0, {{"<", hg["unlabeled-match"]}, distant_label_24}, "left-off"}
        elseif right_off_3f then
          target.beacon = {dec((right_bound - col)), {distant_label_24, {">", hg["unlabeled-match"]}}}
        else
        target.beacon = nil
        end
      elseif _repeat then
        local _367_
        if squeezed_3f0 then
          _367_ = 1
        else
          _367_ = 2
        end
        target.beacon = {_367_, {distant_label_24}}
      elseif overlapped_3f then
        target.beacon = {1, {overlapped_distant_label_24}}
      elseif squeezed_3f0 then
        target.beacon = {0, {masked_char_24, distant_label_24}}
      else
        target.beacon = {2, {distant_label_24}}
      end
    elseif (_357_ == "inactive") then
      target.beacon = nil
    else
    target.beacon = nil
    end
  end
  return nil
end
local function set_beacons(target_list, _372_)
  local _arg_373_ = _372_
  local _repeat = _arg_373_["repeat"]
  for _, target in ipairs(target_list) do
    set_beacon(target, _repeat)
  end
  return nil
end
local function light_up_beacons(target_list, ghost_beacons_3f, _3fstart_idx)
  for i = (_3fstart_idx or 1), #target_list do
    local _let_374_ = target_list[i]
    local target = _let_374_
    local _let_375_ = _let_374_["pos"]
    local line = _let_375_[1]
    local col = _let_375_[2]
    local _376_ = target.beacon
    if ((type(_376_) == "table") and (nil ~= (_376_)[1]) and (nil ~= (_376_)[2]) and true) then
      local offset = (_376_)[1]
      local chunks = (_376_)[2]
      local _3fleft_off_3f = (_376_)[3]
      local function _378_()
        local t_377_ = target.wininfo
        if (nil ~= t_377_) then
          t_377_ = (t_377_).bufnr
        end
        return t_377_
      end
      local _380_
      if _3fleft_off_3f then
        _380_ = 0
      else
      _380_ = nil
      end
      api.nvim_buf_set_extmark((_378_() or 0), hl.ns, dec(line), dec((col + offset)), {priority = hl.priority.label, virt_text = chunks, virt_text_pos = "overlay", virt_text_win_col = _380_})
      if ghost_beacons_3f then
        local curcol = vim.fn.col(".")
        local col_delta = abs((curcol - col))
        local min_col_delta = 5
        if (col_delta > min_col_delta) then
          local chunks0
          do
            local _382_ = target["label-state"]
            if (_382_ == "active-primary") then
              chunks0 = {{target.label, hl.group["label-overlapped"]}}
            elseif (_382_ == "active-secondary") then
              chunks0 = {{target.label, hl.group["label-distant-overlapped"]}}
            else
            chunks0 = nil
            end
          end
          api.nvim_buf_set_extmark(0, hl.ns, dec(line), 0, {priority = hl.priority.label, virt_text = chunks0, virt_text_pos = "overlay", virt_text_win_col = dec(vim.fn.virtcol("."))})
        end
      end
    end
  end
  return nil
end
local function get_target_with_active_primary_label(target_list, input)
  local res = nil
  for _, _387_ in ipairs(target_list) do
    local _each_388_ = _387_
    local target = _each_388_
    local label = _each_388_["label"]
    local label_state = _each_388_["label-state"]
    if res then break end
    if ((label == input) and (label_state == "active-primary")) then
      res = target
    end
  end
  return res
end
local function ignore_input_until_timeout(char_to_ignore)
  local _390_ = opts.jump_to_unique_chars
  if ((type(_390_) == "table") and (nil ~= (_390_).safety_timeout)) then
    local timeout = (_390_).safety_timeout
    local _391_ = get_input(timeout)
    if (nil ~= _391_) then
      local input = _391_
      if (input ~= char_to_ignore) then
        return vim.fn.feedkeys(input, "i")
      end
    end
  end
end
local sx = {state = {cold = {["reverse?"] = nil, ["x-mode?"] = nil, in1 = nil, in2 = nil}, dot = {in1 = nil, in2 = nil, in3 = nil}}}
sx.go = function(self, reverse_3f, x_mode_3f, repeat_invoc, cross_window_3f, omni_3f)
  local mode = api.nvim_get_mode().mode
  local linewise_3f = (mode:sub(-1) == "V")
  local op_mode_3f = mode:match("o")
  local change_op_3f = (op_mode_3f and (vim.v.operator == "c"))
  local delete_op_3f = (op_mode_3f and (vim.v.operator == "d"))
  local dot_repeatable_op_3f = (op_mode_3f and not omni_3f and (vim.v.operator ~= "y"))
  local instant_repeat_3f = (type(repeat_invoc) == "table")
  local instant_state
  if instant_repeat_3f then
    instant_state = repeat_invoc
  else
  instant_state = nil
  end
  local cold_repeat_3f = (repeat_invoc == "cold")
  local dot_repeat_3f = (repeat_invoc == "dot")
  local invoked_as_reverse_3f = reverse_3f
  local reverse_3f0
  if cold_repeat_3f then
    local function _396_(_241)
      if invoked_as_reverse_3f then
        return not _241
      else
        return _241
      end
    end
    reverse_3f0 = _396_(self.state.cold["reverse?"])
  else
    reverse_3f0 = reverse_3f
  end
  local x_mode_3f0
  if cold_repeat_3f then
    x_mode_3f0 = self.state.cold["x-mode?"]
  else
    x_mode_3f0 = x_mode_3f
  end
  local _3ftarget_windows
  local function _400_()
    if cross_window_3f then
      return get_targetable_windows(reverse_3f0, omni_3f)
    end
  end
  local function _401_()
    if instant_repeat_3f then
      return instant_state["target-windows"]
    end
  end
  _3ftarget_windows = (_400_() or _401_())
  local new_search_3f = not repeat_invoc
  local backspace_repeat_3f = nil
  local to_eol_3f = nil
  local to_pre_eol_3f = nil
  local function get_first_input()
    if instant_repeat_3f then
      return instant_state.in1
    elseif dot_repeat_3f then
      return self.state.dot.in1
    elseif cold_repeat_3f then
      return self.state.cold.in1
    else
      local _402_
      local function _403_()
        local res_2_auto
        do
          res_2_auto = get_input()
        end
        hl:cleanup(_3ftarget_windows)
        return res_2_auto
      end
      local function _404_()
        if change_operation_3f() then
          handle_interrupted_change_op_21()
        end
        do
        end
        doau_when_exists("LightspeedSxLeave")
        doau_when_exists("LightspeedLeave")
        return nil
      end
      _402_ = (_403_() or _404_())
      local function _406_()
        return not omni_3f
      end
      if ((_402_ == "\9") and _406_()) then
        sx:go(not reverse_3f0, x_mode_3f0, false, cross_window_3f)
        return nil
      elseif (_402_ == _3cbackspace_3e) then
        backspace_repeat_3f = true
        new_search_3f = false
        local function _407_()
          if change_operation_3f() then
            handle_interrupted_change_op_21()
          end
          do
            echo_no_prev_search()
          end
          doau_when_exists("LightspeedSxLeave")
          doau_when_exists("LightspeedLeave")
          return nil
        end
        return (self.state.cold.in1 or _407_())
      elseif (nil ~= _402_) then
        local _in = _402_
        return _in
      end
    end
  end
  local function update_state_2a(in1)
    local function _413_(_411_)
      local _arg_412_ = _411_
      local cold = _arg_412_["cold"]
      local dot = _arg_412_["dot"]
      if new_search_3f then
        if cold then
          local _414_ = cold
          _414_["in1"] = in1
          _414_["x-mode?"] = x_mode_3f0
          _414_["reverse?"] = reverse_3f0
          self.state.cold = _414_
        end
        if dot then
          if dot_repeatable_op_3f then
            do
              local _416_ = dot
              _416_["in1"] = in1
              _416_["x-mode?"] = x_mode_3f0
              self.state.dot = _416_
            end
            return nil
          end
        end
      end
    end
    return _413_
  end
  local jump_to_21
  do
    local first_jump_3f = true
    local function _420_(target, _3fto_pre_eol_3f, _3fsave_winview_3f)
      if target.wininfo then
        api.nvim_set_current_win(target.wininfo.winid)
        if _3fsave_winview_3f then
          target["winview"] = vim.fn.winsaveview()
        end
      end
      local to_pre_eol_3f0 = (_3fto_pre_eol_3f or to_pre_eol_3f)
      local adjusted_pos
      local function _423_()
        if to_eol_3f then
          if op_mode_3f then
            return push_cursor_21("fwd")
          end
        elseif to_pre_eol_3f0 then
          if (op_mode_3f and x_mode_3f0) then
            return push_cursor_21("fwd")
          end
        elseif x_mode_3f0 then
          push_cursor_21("fwd")
          if reverse_3f0 then
            return push_cursor_21("fwd")
          end
        end
      end
      adjusted_pos = jump_to_21_2a(target.pos, {["add-to-jumplist?"] = (first_jump_3f and not instant_repeat_3f), ["inclusive-motion?"] = (x_mode_3f0 and not reverse_3f0), ["reverse?"] = reverse_3f0, adjust = _423_, mode = mode})
      first_jump_3f = false
      return adjusted_pos
    end
    jump_to_21 = _420_
  end
  local function highlight_new_curpos_and_op_area(from_pos, to_pos)
    local motion_force = get_motion_force(mode)
    local blockwise_3f = (motion_force == _3cctrl_v_3e)
    local function _429_()
      if reverse_3f0 then
        return to_pos
      else
        return from_pos
      end
    end
    local _let_428_ = _429_()
    local startline = _let_428_[1]
    local startcol = _let_428_[2]
    local start = _let_428_
    local function _431_()
      if reverse_3f0 then
        return from_pos
      else
        return to_pos
      end
    end
    local _let_430_ = _431_()
    local _ = _let_430_[1]
    local endcol = _let_430_[2]
    local _end = _let_430_
    local top_left = {startline, min(startcol, endcol)}
    local new_curpos
    if op_mode_3f then
      if blockwise_3f then
        new_curpos = top_left
      else
        new_curpos = start
      end
    else
      new_curpos = to_pos
    end
    if not change_op_3f then
      highlight_cursor(new_curpos)
    end
    if op_mode_3f then
      highlight_range(hl.group["pending-op-area"], map(dec, start), map(dec, _end), {["inclusive-motion?"] = (x_mode_3f0 and not reverse_3f0), ["motion-force"] = motion_force})
    end
    return vim.cmd("redraw")
  end
  local function get_sublist(targets, ch)
    local _436_ = targets.sublists[ch]
    if (nil ~= _436_) then
      local sublist = _436_
      local _let_437_ = sublist
      local _let_438_ = _let_437_[1]
      local _let_439_ = _let_438_["pos"]
      local line = _let_439_[1]
      local col = _let_439_[2]
      local rest = {(table.unpack or unpack)(_let_437_, 2)}
      local target_tail = {line, inc(col)}
      local prev_pos = vim.fn.searchpos("\\_.", "nWb")
      local cursor_touches_first_target_3f = same_pos_3f(target_tail, prev_pos)
      if (cold_repeat_3f and x_mode_3f0 and reverse_3f0 and cursor_touches_first_target_3f) then
        if not empty_3f(rest) then
          return rest
        end
      else
        return sublist
      end
    end
  end
  local function get_last_input(sublist, start_idx)
    local next_group_key = replace_keycodes(opts.special_keys.next_match_group)
    local prev_group_key = replace_keycodes(opts.special_keys.prev_match_group)
    local function recur(group_offset, initial_invoc_3f)
      local _443_
      if (cold_repeat_3f or backspace_repeat_3f) then
        _443_ = "cold"
      elseif instant_repeat_3f then
        if sublist["autojump?"] then
          _443_ = "instant"
        else
          _443_ = "instant-unsafe"
        end
      else
      _443_ = nil
      end
      set_beacons(sublist, {["repeat"] = _443_})
      do
        if not (cold_repeat_3f or instant_repeat_3f) then
          grey_out_search_area(reverse_3f0, _3ftarget_windows, omni_3f)
        end
        do
          light_up_beacons(sublist, (linewise_3f and to_eol_3f and not instant_repeat_3f), start_idx)
        end
        highlight_cursor()
        vim.cmd("redraw")
      end
      local _447_
      do
        local res_2_auto
        do
          local function _448_()
            if initial_invoc_3f then
              return opts.exit_after_idle_msecs.labeled
            end
          end
          res_2_auto = get_input(_448_())
        end
        hl:cleanup(_3ftarget_windows)
        _447_ = res_2_auto
      end
      if (nil ~= _447_) then
        local input = _447_
        if (sublist["autojump?"] and not user_forced_autojump_3f()) then
          return {input, 0}
        elseif (((input == next_group_key) or (input == prev_group_key)) and not instant_repeat_3f) then
          local labels = sublist["label-set"]
          local num_of_groups = ceil((#sublist / #labels))
          local max_offset = dec(num_of_groups)
          local group_offset_2a
          local _450_
          do
            local _449_ = input
            if (_449_ == next_group_key) then
              _450_ = inc
            else
              local _ = _449_
              _450_ = dec
            end
          end
          group_offset_2a = clamp(_450_(group_offset), 0, max_offset)
          set_label_states(sublist, {["group-offset"] = group_offset_2a})
          return recur(group_offset_2a)
        else
          return {input, group_offset}
        end
      end
    end
    return recur(0, true)
  end
  local function restore_view_on_winleave(curr_target, next_target)
    local _457_
    do
      local t_456_ = curr_target
      if (nil ~= t_456_) then
        t_456_ = (t_456_).wininfo
      end
      if (nil ~= t_456_) then
        t_456_ = (t_456_).winid
      end
      _457_ = t_456_
    end
    local _461_
    do
      local t_460_ = next_target
      if (nil ~= t_460_) then
        t_460_ = (t_460_).wininfo
      end
      if (nil ~= t_460_) then
        t_460_ = (t_460_).winid
      end
      _461_ = t_460_
    end
    if (not instant_repeat_3f and (_457_ ~= _461_)) then
      if curr_target.winview then
        return vim.fn.winrestview(curr_target.winview)
      end
    end
  end
  enter("sx")
  if not repeat_invoc then
    echo("")
    if not (cold_repeat_3f or instant_repeat_3f) then
      grey_out_search_area(reverse_3f0, _3ftarget_windows, omni_3f)
    end
    do
      if opts.jump_to_unique_chars then
        highlight_unique_chars(reverse_3f0, _3ftarget_windows, omni_3f)
      end
    end
    highlight_cursor()
    vim.cmd("redraw")
  end
  local _469_ = get_first_input()
  if (nil ~= _469_) then
    local in1 = _469_
    local _
    to_eol_3f = (in1 == "\13")
    _ = nil
    local from_pos = get_cursor_pos()
    local update_state = update_state_2a(in1)
    local prev_in2
    if instant_repeat_3f then
      prev_in2 = instant_state.in2
    elseif (cold_repeat_3f or backspace_repeat_3f) then
      prev_in2 = self.state.cold.in2
    elseif dot_repeat_3f then
      prev_in2 = self.state.dot.in2
    else
    prev_in2 = nil
    end
    local _471_
    local function _473_()
      local t_472_ = instant_state
      if (nil ~= t_472_) then
        t_472_ = (t_472_).sublist
      end
      return t_472_
    end
    local function _475_()
      if change_operation_3f() then
        handle_interrupted_change_op_21()
      end
      do
        echo_not_found((in1 .. (prev_in2 or "")))
      end
      doau_when_exists("LightspeedSxLeave")
      doau_when_exists("LightspeedLeave")
      return nil
    end
    _471_ = (_473_() or get_targets(in1, reverse_3f0, _3ftarget_windows, omni_3f) or _475_())
    local function _477_()
      local _0 = (((_471_)[1]).pair)[1]
      local ch2 = (((_471_)[1]).pair)[2]
      local only = (_471_)[1]
      return opts.jump_to_unique_chars
    end
    if (((type(_471_) == "table") and ((type((_471_)[1]) == "table") and ((type(((_471_)[1]).pair) == "table") and true and (nil ~= (((_471_)[1]).pair)[2]))) and ((_471_)[2] == nil)) and _477_()) then
      local _0 = (((_471_)[1]).pair)[1]
      local ch2 = (((_471_)[1]).pair)[2]
      local only = (_471_)[1]
      if (new_search_3f or (ch2 == prev_in2)) then
        do
          if dot_repeatable_op_3f then
            set_dot_repeat(replace_keycodes(get_plug_key("sx", reverse_3f0, x_mode_3f0, "dot")))
          end
          update_state({cold = {in2 = ch2}, dot = {in2 = ch2, in3 = opts.labels[1]}})
          local to_pos = jump_to_21(only, (ch2 == "\13"))
          if new_search_3f then
            local res_2_auto
            do
              highlight_new_curpos_and_op_area(from_pos, to_pos)
              res_2_auto = ignore_input_until_timeout(ch2)
            end
            hl:cleanup(_3ftarget_windows)
          end
        end
        doau_when_exists("LightspeedSxLeave")
        doau_when_exists("LightspeedLeave")
        return nil
      else
        if change_operation_3f() then
          handle_interrupted_change_op_21()
        end
        do
          echo_not_found((in1 .. prev_in2))
        end
        doau_when_exists("LightspeedSxLeave")
        doau_when_exists("LightspeedLeave")
        return nil
      end
    elseif (nil ~= _471_) then
      local targets = _471_
      if not instant_repeat_3f then
        local _482_ = targets
        populate_sublists(_482_)
        set_sublist_attributes(_482_, to_eol_3f)
        set_labels(_482_, to_eol_3f)
        set_initial_label_states(_482_)
      end
      if (new_search_3f and not to_eol_3f) then
        do
          local _484_ = targets
          set_shortcuts_and_populate_shortcuts_map(_484_)
          set_beacons(_484_, {["repeat"] = nil})
        end
        if not (cold_repeat_3f or instant_repeat_3f) then
          grey_out_search_area(reverse_3f0, _3ftarget_windows, omni_3f)
        end
        do
          light_up_beacons(targets, (linewise_3f and to_eol_3f and not instant_repeat_3f))
        end
        highlight_cursor()
        vim.cmd("redraw")
      end
      local _487_
      local function _488_()
        if to_eol_3f then
          return ""
        end
      end
      local function _489_()
        local res_2_auto
        do
          res_2_auto = get_input()
        end
        hl:cleanup(_3ftarget_windows)
        return res_2_auto
      end
      local function _490_()
        if change_operation_3f() then
          handle_interrupted_change_op_21()
        end
        do
        end
        doau_when_exists("LightspeedSxLeave")
        doau_when_exists("LightspeedLeave")
        return nil
      end
      _487_ = (prev_in2 or _488_() or _489_() or _490_())
      if (nil ~= _487_) then
        local in2 = _487_
        local _492_
        do
          local t_493_ = targets.shortcuts
          if (nil ~= t_493_) then
            t_493_ = (t_493_)[in2]
          end
          _492_ = t_493_
        end
        if ((type(_492_) == "table") and ((type((_492_).pair) == "table") and true and (nil ~= ((_492_).pair)[2]))) then
          local _0 = ((_492_).pair)[1]
          local ch2 = ((_492_).pair)[2]
          local shortcut = _492_
          do
            if dot_repeatable_op_3f then
              set_dot_repeat(replace_keycodes(get_plug_key("sx", reverse_3f0, x_mode_3f0, "dot")))
            end
            update_state({cold = {in2 = ch2}, dot = {in2 = ch2, in3 = in2}})
            jump_to_21(shortcut, (ch2 == "\13"))
          end
          doau_when_exists("LightspeedSxLeave")
          doau_when_exists("LightspeedLeave")
          return nil
        else
          local _0 = _492_
          to_pre_eol_3f = (in2 == "\13")
          update_state({cold = {in2 = in2}})
          local _496_
          local function _498_()
            local t_497_ = instant_state
            if (nil ~= t_497_) then
              t_497_ = (t_497_).sublist
            end
            return t_497_
          end
          local function _500_()
            if change_operation_3f() then
              handle_interrupted_change_op_21()
            end
            do
              echo_not_found((in1 .. in2))
            end
            doau_when_exists("LightspeedSxLeave")
            doau_when_exists("LightspeedLeave")
            return nil
          end
          _496_ = (_498_() or get_sublist(targets, in2) or _500_())
          if ((type(_496_) == "table") and (nil ~= (_496_)[1]) and ((_496_)[2] == nil)) then
            local only = (_496_)[1]
            do
              if dot_repeatable_op_3f then
                set_dot_repeat(replace_keycodes(get_plug_key("sx", reverse_3f0, x_mode_3f0, "dot")))
              end
              update_state({dot = {in2 = in2, in3 = (opts.labels or opts.safe_labels)[1]}})
              jump_to_21(only)
            end
            doau_when_exists("LightspeedSxLeave")
            doau_when_exists("LightspeedLeave")
            return nil
          elseif ((type(_496_) == "table") and (nil ~= (_496_)[1])) then
            local first = (_496_)[1]
            local sublist = _496_
            local autojump_3f = sublist["autojump?"]
            local curr_idx
            local function _504_()
              local t_503_ = instant_state
              if (nil ~= t_503_) then
                t_503_ = (t_503_).idx
              end
              return t_503_
            end
            local function _506_()
              if autojump_3f then
                return 1
              else
                return 0
              end
            end
            curr_idx = (_504_() or _506_())
            local from_reverse_cold_repeat_3f
            if instant_repeat_3f then
              from_reverse_cold_repeat_3f = instant_state["from-reverse-cold-repeat?"]
            else
              from_reverse_cold_repeat_3f = (cold_repeat_3f and invoked_as_reverse_3f)
            end
            if (autojump_3f and not instant_repeat_3f) then
              jump_to_21(first, nil, true)
            end
            local _509_
            local function _510_()
              if (dot_repeat_3f and self.state.dot.in3) then
                return {self.state.dot.in3, 0}
              end
            end
            local function _511_()
              if change_operation_3f() then
                handle_interrupted_change_op_21()
              end
              do
              end
              doau_when_exists("LightspeedSxLeave")
              doau_when_exists("LightspeedLeave")
              return nil
            end
            _509_ = (_510_() or get_last_input(sublist, inc(curr_idx)) or _511_())
            if ((type(_509_) == "table") and (nil ~= (_509_)[1]) and (nil ~= (_509_)[2])) then
              local in3 = (_509_)[1]
              local group_offset = (_509_)[2]
              local _513_
              if not (op_mode_3f or (group_offset > 0)) then
                _513_ = get_repeat_action(in3, "sx", x_mode_3f0, instant_repeat_3f, from_reverse_cold_repeat_3f)
              else
              _513_ = nil
              end
              if (nil ~= _513_) then
                local action = _513_
                local idx
                do
                  local _515_ = action
                  if (_515_ == "repeat") then
                    idx = min(inc(curr_idx), #targets)
                  elseif (_515_ == "revert") then
                    idx = max(dec(curr_idx), 1)
                  else
                  idx = nil
                  end
                end
                local neighbor = sublist[idx]
                restore_view_on_winleave(first, neighbor)
                jump_to_21(neighbor)
                return sx:go(reverse_3f0, x_mode_3f0, {["from-reverse-cold-repeat?"] = from_reverse_cold_repeat_3f, ["target-windows"] = _3ftarget_windows, idx = idx, in1 = in1, in2 = in2, sublist = sublist})
              else
                local _1 = _513_
                local _517_
                if not (instant_repeat_3f and not autojump_3f) then
                  _517_ = get_target_with_active_primary_label(sublist, in3)
                else
                _517_ = nil
                end
                if (nil ~= _517_) then
                  local target = _517_
                  do
                    if dot_repeatable_op_3f then
                      set_dot_repeat(replace_keycodes(get_plug_key("sx", reverse_3f0, x_mode_3f0, "dot")))
                    end
                    local _520_
                    if (group_offset > 0) then
                      _520_ = nil
                    else
                      _520_ = in3
                    end
                    update_state({dot = {in2 = in2, in3 = _520_}})
                    restore_view_on_winleave(first, target)
                    jump_to_21(target)
                  end
                  doau_when_exists("LightspeedSxLeave")
                  doau_when_exists("LightspeedLeave")
                  return nil
                else
                  local _2 = _517_
                  if (autojump_3f or instant_repeat_3f) then
                    do
                      if dot_repeatable_op_3f then
                        set_dot_repeat(replace_keycodes(get_plug_key("sx", reverse_3f0, x_mode_3f0, "dot")))
                      end
                      vim.fn.feedkeys(in3, "i")
                    end
                    doau_when_exists("LightspeedSxLeave")
                    doau_when_exists("LightspeedLeave")
                    return nil
                  else
                    if change_operation_3f() then
                      handle_interrupted_change_op_21()
                    end
                    do
                    end
                    doau_when_exists("LightspeedSxLeave")
                    doau_when_exists("LightspeedLeave")
                    return nil
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
local temporary_editor_opts = {["vim.bo.modeline"] = false, ["vim.wo.conceallevel"] = 0, ["vim.wo.scrolloff"] = 0}
local saved_editor_opts = {}
local function save_editor_opts()
  for opt, _ in pairs(temporary_editor_opts) do
    local _let_533_ = vim.split(opt, ".", true)
    local _0 = _let_533_[1]
    local scope = _let_533_[2]
    local name = _let_533_[3]
    local _534_
    if (opt == "vim.wo.scrolloff") then
      _534_ = api.nvim_eval("&l:scrolloff")
    else
      _534_ = _G.vim[scope][name]
    end
    saved_editor_opts[opt] = _534_
  end
  return nil
end
local function set_editor_opts(opts0)
  for opt, val in pairs(opts0) do
    local _let_536_ = vim.split(opt, ".", true)
    local _ = _let_536_[1]
    local scope = _let_536_[2]
    local name = _let_536_[3]
    _G.vim[scope][name] = val
  end
  return nil
end
local function set_temporary_editor_opts()
  return set_editor_opts(temporary_editor_opts)
end
local function restore_editor_opts()
  return set_editor_opts(saved_editor_opts)
end
local function set_plug_keys()
  local plug_keys = {{"<Plug>Lightspeed_s", "sx:go(false)"}, {"<Plug>Lightspeed_S", "sx:go(true)"}, {"<Plug>Lightspeed_x", "sx:go(false, true)"}, {"<Plug>Lightspeed_X", "sx:go(true, true)"}, {"<Plug>Lightspeed_gs", "sx:go(false, nil, nil, true)"}, {"<Plug>Lightspeed_gS", "sx:go(true, nil, nil, true)"}, {"<Plug>Lightspeed_omni_s", "sx:go(nil, false, nil, nil, true)"}, {"<Plug>Lightspeed_omni_gs", "sx:go(nil, false, nil, true, true)"}, {"<Plug>Lightspeed_f", "ft:go(false)"}, {"<Plug>Lightspeed_F", "ft:go(true)"}, {"<Plug>Lightspeed_t", "ft:go(false, true)"}, {"<Plug>Lightspeed_T", "ft:go(true, true)"}, {"<Plug>Lightspeed_;_sx", "sx:go(false, nil, 'cold')"}, {"<Plug>Lightspeed_,_sx", "sx:go(true, nil, 'cold')"}, {"<Plug>Lightspeed_;_ft", "ft:go(false, nil, 'cold')"}, {"<Plug>Lightspeed_,_ft", "ft:go(true, nil, 'cold')"}}
  for _, _537_ in ipairs(plug_keys) do
    local _each_538_ = _537_
    local lhs = _each_538_[1]
    local rhs_call = _each_538_[2]
    for _0, mode in ipairs({"n", "x", "o"}) do
      api.nvim_set_keymap(mode, lhs, ("<cmd>lua require'lightspeed'." .. rhs_call .. "<cr>"), {noremap = true, silent = true})
    end
  end
  for _, _539_ in ipairs({{"<Plug>Lightspeed_dotrepeat_s", "sx:go(false, false, 'dot')"}, {"<Plug>Lightspeed_dotrepeat_S", "sx:go(true, false, 'dot')"}, {"<Plug>Lightspeed_dotrepeat_x", "sx:go(false, true, 'dot')"}, {"<Plug>Lightspeed_dotrepeat_X", "sx:go(true, true, 'dot')"}, {"<Plug>Lightspeed_dotrepeat_f", "ft:go(false, false, 'dot')"}, {"<Plug>Lightspeed_dotrepeat_F", "ft:go(true, false, 'dot')"}, {"<Plug>Lightspeed_dotrepeat_t", "ft:go(false, true, 'dot')"}, {"<Plug>Lightspeed_dotrepeat_T", "ft:go(true, true, 'dot')"}}) do
    local _each_540_ = _539_
    local lhs = _each_540_[1]
    local rhs_call = _each_540_[2]
    api.nvim_set_keymap("o", lhs, ("<cmd>lua require'lightspeed'." .. rhs_call .. "<cr>"), {noremap = true, silent = true})
  end
  return nil
end
local function set_default_keymaps()
  local default_keymaps = {{"n", "s", "<Plug>Lightspeed_s"}, {"n", "S", "<Plug>Lightspeed_S"}, {"x", "s", "<Plug>Lightspeed_s"}, {"x", "S", "<Plug>Lightspeed_S"}, {"o", "z", "<Plug>Lightspeed_s"}, {"o", "Z", "<Plug>Lightspeed_S"}, {"n", "gs", "<Plug>Lightspeed_gs"}, {"n", "gS", "<Plug>Lightspeed_gS"}, {"o", "x", "<Plug>Lightspeed_x"}, {"o", "X", "<Plug>Lightspeed_X"}, {"n", "f", "<Plug>Lightspeed_f"}, {"n", "F", "<Plug>Lightspeed_F"}, {"x", "f", "<Plug>Lightspeed_f"}, {"x", "F", "<Plug>Lightspeed_F"}, {"o", "f", "<Plug>Lightspeed_f"}, {"o", "F", "<Plug>Lightspeed_F"}, {"n", "t", "<Plug>Lightspeed_t"}, {"n", "T", "<Plug>Lightspeed_T"}, {"x", "t", "<Plug>Lightspeed_t"}, {"x", "T", "<Plug>Lightspeed_T"}, {"o", "t", "<Plug>Lightspeed_t"}, {"o", "T", "<Plug>Lightspeed_T"}, {"n", ";", "<Plug>Lightspeed_;_ft"}, {"x", ";", "<Plug>Lightspeed_;_ft"}, {"o", ";", "<Plug>Lightspeed_;_ft"}, {"n", ",", "<Plug>Lightspeed_,_ft"}, {"x", ",", "<Plug>Lightspeed_,_ft"}, {"o", ",", "<Plug>Lightspeed_,_ft"}}
  for _, _541_ in ipairs(default_keymaps) do
    local _each_542_ = _541_
    local mode = _each_542_[1]
    local lhs = _each_542_[2]
    local rhs = _each_542_[3]
    if ((vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0)) then
      api.nvim_set_keymap(mode, lhs, rhs, {silent = true})
    end
  end
  return nil
end
init_highlight()
set_plug_keys()
if not vim.g.lightspeed_no_default_keymaps then
  set_default_keymaps()
end
vim.cmd("augroup lightspeed_reinit_highlight\n   autocmd!\n   autocmd ColorScheme * lua require'lightspeed'.init_highlight()\n   augroup end")
vim.cmd("augroup lightspeed_editor_opts\n   autocmd!\n   autocmd User LightspeedEnter lua require'lightspeed'.save_editor_opts(); require'lightspeed'.set_temporary_editor_opts()\n   autocmd User LightspeedLeave lua require'lightspeed'.restore_editor_opts()\n   augroup end")
return {ft = ft, init_highlight = init_highlight, opts = opts, restore_editor_opts = restore_editor_opts, save_editor_opts = save_editor_opts, set_default_keymaps = set_default_keymaps, set_temporary_editor_opts = set_temporary_editor_opts, setup = setup, sx = sx}
