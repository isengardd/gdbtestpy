# 打印gdb断点的信息
# GDB 自动化操作的技术 https://segmentfault.com/a/1190000005367875
python
from collections import defaultdict,namedtuple

ADDRESS_POOL = {}

class AttachNewData(gdb.Function):
	def __init__(self):
		super(self.__class__, self).__init__('AttachNewData')

	def invoke(self, address):
		ADDRESS_POOL[int(str(address),16)] = 0
		#gdb.execute('c')
		#gdb.execute('p ' + str(address))
		return len(ADDRESS_POOL)

class DetachNewData(gdb.Function):
	def __init__(self):
		super(self.__class__, self).__init__('DetachNewData')

	def invoke(self, address):
		ret = 0
		if int(str(address),16) in ADDRESS_POOL:
			del ADDRESS_POOL[int(str(address),16)]	
			ret = len(ADDRESS_POOL)	
		#gdb.execute('p ' + str(address))
		#for k,v in ADDRESS_POOL.items():
		#	gdb.execute('p ' + str(k))		
		return ret #len(ADDRESS_POOL)		

class DeleteData(gdb.Function):
        def __init__(self):
                super(self.__class__, self).__init__('DeleteData')

        def invoke(self, address):
		if int(str(address),16) in ADDRESS_POOL:
			#内存还在对象中，这里不执行c命令，直接break
			return 1
		#else:
		#	gdb.execute('c')
		return 0

class ClearData(gdb.Function):
        def __init__(self):
                super(self.__class__, self).__init__('ClearData')
        def invoke(self):
		ADDRESS_POOL.clear()
		return 0

#向gdb会话注册该函数
AttachNewData()
DetachNewData()
DeleteData()
ClearData()

end

