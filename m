Return-Path: <kvm-ppc+bounces-92-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A046B8997A3
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Apr 2024 10:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2926A284640
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Apr 2024 08:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 285981465A5;
	Fri,  5 Apr 2024 08:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UOD7GZdy"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588CC14658F
	for <kvm-ppc@vger.kernel.org>; Fri,  5 Apr 2024 08:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712305029; cv=none; b=ERrcVCeAuMt/MHWDsVOqz5VFctRX8PIllBpUUHSloWE5Q3po1BuPfVNe1ODsKblxQooPIGskmZ3DJJw/OvpJqMlGInxFICym6hvGTifcPSHna2o3B3Z91WENFFYQV/gHEkdGpZHnULcb21LE5GHn5OUaQrTM2ij4vUL9qXbDDbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712305029; c=relaxed/simple;
	bh=tmpbUGiIllRqFUF5lPH8Pls8eFOItac0ku/+OOVstE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+oPhi2KIUlEs1m3XVYXKBfD6X7vZn5ZvjrhMusx1W+FF9vaUSkaisT0KH+o0xGVtcIiJ1F5nM/BAt1gndfQvyWWaDgfhRcXvh7ZDpUNduTsAqWsGowUnElhJcbMkB61gdpsv1/ZKWhsE5ybIOlMo7XzsRgolNb4UqWHEkYWu+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UOD7GZdy; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4357vB1A003887;
	Fri, 5 Apr 2024 08:16:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=n2Eu4WthNFdTdEiB7V8nP5J0wqpAXC8WQRMsrsAd/P0=;
 b=UOD7GZdyr9Y4UqULRgMjN8K7Uf/gxTq8eXw0+AKCKCd3P8A3OtyHc/jrGgmcMh6dppj9
 iqm3osAf5HAZ8T730kzqlhjUNLQxX0Nlq+ptPVqPSwOExJNb5WLnRIQwlbOz6zTMdNdQ
 Fut7XgGRyQzG8rs9FI5K9psU3dQMeRIBRq1WurQxm+BWLTUt3Lt1byHN/G7sXZ6RmoBx
 OUT0Vd2UFz0mrJ7AqgphG9OTG9ZAhcGrDDPsEcuKosbHK1x8VGGNJUzAs4ZLbl3For/n
 R84jZ1PXcApDvNfiG5GNpPXZ6W4bdIQl/JPwrUyG2kEdLtXuCaFdpspf3hw38e+CUglV TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xadc181qf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Apr 2024 08:16:56 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4358CBMb031428;
	Fri, 5 Apr 2024 08:16:55 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xadc181qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Apr 2024 08:16:55 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43560l4U007718;
	Fri, 5 Apr 2024 08:16:54 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3x9epwsckw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Apr 2024 08:16:54 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4358Go7R49676776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Apr 2024 08:16:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3D6C2004F;
	Fri,  5 Apr 2024 08:16:50 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9A5E20063;
	Fri,  5 Apr 2024 08:16:48 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.171.66.52])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  5 Apr 2024 08:16:48 +0000 (GMT)
Date: Fri, 5 Apr 2024 13:46:44 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
        Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v4] slof/fs/packages/disk-label.fs: improve checking for
 DOS boot partitions
Message-ID: <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LPK6euYY6AYMdjV1zW6_Fo-IVbc7_byi
X-Proofpoint-ORIG-GUID: dHo5vxR1h43AlSDkX4_e_IcGbK1irjHp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-05_07,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404050060

Hi,

On 2024-04-05 14:46:14, Alexey Kardashevskiy wrote:
> 
> 
> On Thu, 4 Apr 2024, at 18:18, Kautuk Consul wrote:
> > On 2024-04-04 11:35:43, Alexey Kardashevskiy wrote:
> > > First, sorry I am late into the discussion. Comments below.
> > > 
> > > 
> > > On Thu, 28 Mar 2024, at 17:00, Kautuk Consul wrote:
> > > > While testing with a qcow2 with a DOS boot partition it was found that
> > > > when we set the logical_block_size in the guest XML to >512 then the
> > > > boot would fail in the following interminable loop:
> > > 
> > > Why would anyone tweak this? And when you do, what happens inside the SLOF, does it keep using 512?
> > Well, we had an image with DOS boot partition and we tested it with
> > logical_block_size = 1024 and got this infinite loop.
> 
> This does not really answer to "why" ;)

Well, my point is that it is tweakable in virsh/qemu and maybe we should be
handling this error in configuration in SLOF properly ? There shouldn't
be the possibility of an interminable loop in the software anywhere,
right ? :-)

> 
> > In SLOF the block-size becomes what we configure in the
> > logical_block_size parameter. This same issue doesn't arise with GPT.
> 
> How is GPT different in this regard?

In GPT the sector number 1 contains the GPT headers, not
sector 0 as in the case of DOS boot partition. So if the block-size is
incorrect, the GPT magic number itself isn't found and the "E3404: Not a
bootable device!" error is immediately thrown.

> 
> > > > <SNIP>
> > > > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > </SNIP>
> > > > 
> > > > Change the "read-sector" Forth subroutine to throw an exception whenever
> > > > it fails to read a full block-size length of sector from the disk.
> > > 
> > > Why not throwing an exception from the "beyond end" message point?
> > > Or fail to open a device if SLOF does not like the block size? I forgot the internals :(
> > This loop is interminable and this "Access beyond end of device!"
> > message continues forever.
> 
> Where is that loop exactly? Put CATCH in there.

That loop is in count-dos-logical-partitions. The reason why I didn't
put a CATCH in there is because there is already another CATCH statement
in do-load in slof/fs/boot.fs which covers this throw. For the other
path that doesn't have a CATCH I have inserted a CATCH in the open
subroutine in disk-label.fs.

> 
> > SLOF doesn't have any option other than to use the block-size that was
> > set in the logical_block_size parameter. It doesn't have any preference
> > as the code is very generic for both DOS as well as GPT.
> > > 
> > > > Also change the "open" method to initiate CATCH exception handling for the calls to
> > > > try-partitions/try-files which will also call read-sector which could potentially
> > > > now throw this new exception.
> > > > 
> > > > After making the above changes, it fails properly with the correct error
> > > > message as follows:
> > > > <SNIP>
> > > > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > virtioblk_transfer: Access beyond end of device!
> > > > 
> > > > E3404: Not a bootable device!
> > > > 
> > > > E3407: Load failed
> > > > 
> > > >   Type 'boot' and press return to continue booting the system.
> > > >   Type 'reset-all' and press return to reboot the system.
> > > > 
> > > > Ready!
> > > > 0 >
> > > > </SNIP>
> > > > 
> > > > Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
> > > > ---
> > > > slof/fs/packages/disk-label.fs | 12 +++++++++---
> > > > 1 file changed, 9 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> > > > index 661c6b0..a6fb231 100644
> > > > --- a/slof/fs/packages/disk-label.fs
> > > > +++ b/slof/fs/packages/disk-label.fs
> > > > @@ -136,7 +136,8 @@ CONSTANT /gpt-part-entry
> > > > : read-sector ( sector-number -- )
> > > >     \ block-size is 0x200 on disks, 0x800 on cdrom drives
> > > >     block-size * 0 seek drop      \ seek to sector
> > > > -   block block-size read drop    \ read sector
> > > > +   block block-size read         \ read sector
> > > > +   block-size < IF throw THEN    \ if we read less than the block-size then throw an exception
> > > 
> > > When it fails, is the number of bytes ever non zero? Thanks,
> > No, it doesn't reach 0. It is lesser than the block-size. For example if
> > we set the logcial_block_size to 1024, the block-size is that much. if
> > we are reading the last sector which is physically only 512 bytes long
> > then we read that 512 bytes which is lesser than 1024, which should be
> > regarded as an error.
> 
> Ah so it only happens when there is an odd number of 512 sectors so reading the last one with block-size==1024 only reads a half => failure, is that right?

Yes. Or, block-size if set to 2048 or 4096 will also show the same problem.

> 
> > > 
> > > > ;
> > > >  
> > > > : (.part-entry) ( part-entry )
> > > > @@ -723,10 +724,15 @@ CREATE GPT-LINUX-PARTITION 10 allot
> > > >     THEN
> > > >  
> > > >     partition IF
> > > > -       try-partitions
> > > > +       ['] try-partitions
> > > >     ELSE
> > > > -       try-files
> > > > +       ['] try-files
> > > >     THEN
> > > > +
> > > > +   \ Catch any exception that might happen due to read-sector failing to read
> > > > +   \ block-size number of bytes from any sector of the disk.
> > > > +   CATCH IF false THEN
> > Segher/Alexey, can we keep this CATCH block or should I remove it ?
> 
> imho the original bug should be handled more gracefully. Seeing exceptions in the code just triggers exceptions in my small brain :) Thanks,

:-). But this is the only other path that doesn't have a CATCH
like the do-load subroutine in slof/fs/boot.fs. According to Segher
there shouldn't ever be a problem with throw because if nothing else the
outer-most interpreter loop's CATCH will catch the exception. But I
thought to cover this throw in read-sector more locally in places near
to this functionality. Because the outermost FORTH SLOF interpreter loop is not
really so related to reading a sector in disk-label.fs.

> 
> > > > +
> > > >     dup 0= IF debug-disk-label? IF ." not found." cr THEN close THEN \ free memory again
> > > > ;
> > > >  
> > > > -- 
> > > > 2.31.1
> > > > 
> > > > 
> > 

