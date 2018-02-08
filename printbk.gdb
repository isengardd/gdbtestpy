# 打印gdb断点的信息
# GDB 自动化操作的技术 https://segmentfault.com/a/1190000005367875
python

class PrintBreakpoint(gdb.Function):
	def __init__(self):
		super(self.__class__, self).__init__('PrintBreakpoint')

	def invoke(self, address):
		bps = gdb.breakpoints()
		if bps is None:
			raise gdb.GdbError('No Breakpoints')
		for bp in bps:
			if bp is None:
				continue
			# 过滤掉非watch的断点
			if bp.type != gdb.BP_WATCHPOINT:
				continue
			
			# 地址信息保存在expression字段 格式: (int*)0x123456
			pos =  bp.expression.find('0x')
			if pos == -1:
				raise gdb.GdbError('0x not in {expression}'.format(expression=bp.expression))
			
			#16进制转10进制后，比较值
			bpaddress = int(bp.expression[pos:],16)
			if bpaddress == address:
				return bp.number
			#if bp.number==1:
				#gdb.execute('p ' + '"struct: {struct}"'.format(struct=" ".join(dir(bp))))
				#for name,value in vars(bp).items():
				#	gdb.execute('p ' + '"{name}={val}"'.format(name=name,val=value))
			#gdb.execute('p ' + '"number: {number}"'.format(number=str(bp.number)))
			#gdb.execute('p ' + '"con: {condition}"'.format(condition=bp.condition))
			#gdb.execute('p ' + '"loc: {location}"'.format(location=bp.location))
			#gdb.execute('p ' + '"command: {command}"'.format(command=bp.commands))
			#gdb.execute('p ' + '"expression: {expres}"'.format(expres=bp.expression))
			#gdb.execute('p ' + '"task: {task}"'.format(task=bp.task))
		raise gdb.GdbError('break at address:0x%x not found!' %(address))

#向gdb会话注册该函数
PrintBreakpoint()
end

# 定义一个临时指令方便调试
define pbreaknum
	set $i=0x603010
	p $PrintBreakpoint($i)
end

