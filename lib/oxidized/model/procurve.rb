class Procurve < Oxidized::Model

  # some models start lines with \r 
  # previous command is repeated followed by "\eE", which sometimes ends up on last line
  prompt /^\r?([\w -]+\eE)?([\w-]+# )$/

  comment  '! '

  # replace all used vt100 control sequences
  expect /\e\[\??\d+(;\d+)*[A-Za-z]/ do |data, re|
    data.gsub re, ''
  end

  expect /Press any key to continue/ do
    send ' '
    ""
  end

  cmd :all do |cfg|
    cfg = cfg.each_line.to_a[1..-3].join
    cfg = cfg.gsub /^\r/, ''
  end

  cmd 'show version' do |cfg|
    comment cfg
  end

  # not supported on all models
  cmd 'show system-information' do |cfg|
    cfg = cfg.split("\n")[0..-8].join("\n")
    comment cfg
  end

  # not supported on all models
  cmd 'show system information' do |cfg|
    cfg = cfg.split("\n")[0..-8].join("\n")
    comment cfg
  end

  cmd 'show running-config'

  cfg :telnet do
    username /Username:/
    password /Password:/
  end

  cfg :telnet, :ssh do
    post_login 'no page'
    pre_logout "logout\ny\nn"
  end

end
