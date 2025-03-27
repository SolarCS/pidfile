require File.join(File.dirname(__FILE__), '..', 'lib','pidfile')

describe PidFile do
  before(:each) do
    @pidfile = PidFile.new(:pidfile => "rspec.pid")
  end

  after(:each) do
    @pidfile.release
  end

  #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
  # Builder Tests
  #-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#

  it "should set defaults upon instantiation" do
    expect(@pidfile.pidfile).to eq "rspec.pid"
    expect(@pidfile.piddir).to eq "/tmp"
    expect(@pidfile.pidpath).to eq "/tmp/rspec.pid"
  end

  it "should secure pidfiles left behind and recycle them for itself" do
    @pidfile.release
    fakepid = 99999999 # absurd number
    open("/tmp/foo.pid", "w") {|f| f.puts fakepid }
    pf = PidFile.new(:pidfile => "foo.pid")
    expect(PidFile.pid(pf.pidpath)).to eq Process.pid
    expect(pf).to be_instance_of(PidFile)
    expect(pf.pid).not_to eq fakepid
    expect(pf.pid).to be_a_kind_of(Integer)
    pf.release
  end

  it "should create a pid file upon instantiation" do
    expect(File.exist?(@pidfile.pidpath)).to eq true
  end

  it "should create a pidfile containing same PID as process" do
    expect(@pidfile.pid).to eq Process.pid
  end

  it "should know if pidfile exists or not" do
    expect(@pidfile.pidfile_exists?).to eq true
    @pidfile.release
    expect(@pidfile.pidfile_exists?).to eq false
  end

  it "should be able to tell if a process is running" do
    expect(@pidfile.alive?).to eq true
  end

  it "should remove the pidfile when the calling application exits" do
    fork do
      exit
    end
    Process.wait
    expect(PidFile.pidfile_exists?).to eq false
  end

  it "should raise an error if a pidfile already exists" do
    expect(lambda { PidFile.new(:pidfile => "rspec.pid") }).to raise_error
  end

  it "should know if a process exists or not - Class method" do
    expect(PidFile.running?('/tmp/rspec.pid')).to eq true
    expect(PidFile.running?('/tmp/foo.pid')).to eq false
  end

  it "should know if it is running - Class method" do
    expect(PidFile.running?).to eq true
  end

  it "should know if it's alive or not" do
    expect(@pidfile.alive?).to eq true
    @pidfile.release
    expect(@pidfile.alive?).to eq false
  end

  it "should remove pidfile and set pid to nil when released" do
    @pidfile.release
    expect(@pidfile.pidfile_exists?).to eq false
    expect(@pidfile.pid).to eq nil
  end

  it "should give a DateTime value for locktime" do
    expect(@pidfile.locktime).to be_instance_of(Time)
  end
end
