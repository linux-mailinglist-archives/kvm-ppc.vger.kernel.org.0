Return-Path: <kvm-ppc+bounces-97-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B1308A62F7
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Apr 2024 07:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDFA41C228A3
	for <lists+kvm-ppc@lfdr.de>; Tue, 16 Apr 2024 05:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2765122F14;
	Tue, 16 Apr 2024 05:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QSvU+4Ko"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F12A8468
	for <kvm-ppc@vger.kernel.org>; Tue, 16 Apr 2024 05:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713245090; cv=none; b=UVBRCZuhjMG3ILUP+vt5+N5eOERrXGDUCnK0lJL96FkD6AWB6EOA8smXw5np4jikfPgJ8ZcanQFZ1RaNbqj4lLWGUSMhakD+71CO5lUlD8dIcENKMt+MZ7ESLWddM7cLyiw7GvK1Ahe8gp2xwOt2pp6t2gUCN+RV+Y3WqiwvimY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713245090; c=relaxed/simple;
	bh=5NovaDPesTxdwFj1AmNJKT/5bHUnxOVNhw1tWBORaM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HeoUz/WX5Q6EIPa2kJ1mpZAVsQXkoJTsDWWrglkRFMkV3NqG+atF959Hc9HoyAu97PNPwK3QvOTqOKt/ErgC7UaKKAQlSzEgDsv4FrEvW5xOOvf0KHlPylI8Gk7AVeknl91Sda0bt5lGh3/coUHhV2lFm5MG4rJXrmQu9bg4Q+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QSvU+4Ko; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43G3N8Bh008144;
	Tue, 16 Apr 2024 05:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=TKxIzREBpFWCMMlzyv2tJ410uuQqZCh6StRj0yU0xIA=;
 b=QSvU+4KoUxUf4okqoEAovrRM0Lc2m8zbZZMlUPw6lSzkZjvhJC+vWMT9EWb6RAAR2FNu
 pQcDBX5jaJfI+iGT9zXbkV3BlhHlsEy40FwZhArIeOPpPLaUMecQXPk/vepMin6fN8ge
 2+kitEZ5GQcJwVRlXPcC8t+z8I2LwfhFDK5kwVFEVlvI0VghJJkN7Qppqp1ig9No2VYr
 GUve1zeFBLZcGi5LDxj5fib1+jLoCBWu8WsNNIW2i2kL6YoFqJQDey57bg+SfbEhoeN4
 FWlSuXRxPW3KdIlparHWHEwv0FmAOqbJzBClC+jQgnTuqghb6Wehqhgl2H5nONPabOW3 Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xhhcd85kf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 05:24:39 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43G5OdVi014948;
	Tue, 16 Apr 2024 05:24:39 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xhhcd85kd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 05:24:39 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43G3Ml87021322;
	Tue, 16 Apr 2024 05:24:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xg6kkbujw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Apr 2024 05:24:38 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43G5OYr035258720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 05:24:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB80220063;
	Tue, 16 Apr 2024 04:37:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBAA4200A8;
	Tue, 16 Apr 2024 04:37:29 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Apr 2024 04:37:19 +0000 (GMT)
Date: Tue, 16 Apr 2024 10:03:33 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v4] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
 <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sgbY54WccLvMH4UtutYv27CADGxIPr7F
X-Proofpoint-ORIG-GUID: YEXSFd7vJAO2ZyAk-iBpYP0yjuqexMK9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_02,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160030

Hi,

On 2024-04-05 13:46:44, Kautuk Consul wrote:
> Hi,
> 
> On 2024-04-05 14:46:14, Alexey Kardashevskiy wrote:
> > 
> > 
> > On Thu, 4 Apr 2024, at 18:18, Kautuk Consul wrote:
> > > On 2024-04-04 11:35:43, Alexey Kardashevskiy wrote:
> > > > First, sorry I am late into the discussion. Comments below.
> > > > 
> > > > 
> > > > On Thu, 28 Mar 2024, at 17:00, Kautuk Consul wrote:
> > > > > While testing with a qcow2 with a DOS boot partition it was found that
> > > > > when we set the logical_block_size in the guest XML to >512 then the
> > > > > boot would fail in the following interminable loop:
> > > > 
> > > > Why would anyone tweak this? And when you do, what happens inside the SLOF, does it keep using 512?
> > > Well, we had an image with DOS boot partition and we tested it with
> > > logical_block_size = 1024 and got this infinite loop.
> > 
> > This does not really answer to "why" ;)
> 
> Well, my point is that it is tweakable in virsh/qemu and maybe we should be
> handling this error in configuration in SLOF properly ? There shouldn't
> be the possibility of an interminable loop in the software anywhere,
> right ? :-)
> 
> > 
> > > In SLOF the block-size becomes what we configure in the
> > > logical_block_size parameter. This same issue doesn't arise with GPT.
> > 
> > How is GPT different in this regard?
> 
> In GPT the sector number 1 contains the GPT headers, not
> sector 0 as in the case of DOS boot partition. So if the block-size is
> incorrect, the GPT magic number itself isn't found and the "E3404: Not a
> bootable device!" error is immediately thrown.
> 
> > 
> > > > > <SNIP>
> > > > > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > </SNIP>
> > > > > 
> > > > > Change the "read-sector" Forth subroutine to throw an exception whenever
> > > > > it fails to read a full block-size length of sector from the disk.
> > > > 
> > > > Why not throwing an exception from the "beyond end" message point?
> > > > Or fail to open a device if SLOF does not like the block size? I forgot the internals :(
> > > This loop is interminable and this "Access beyond end of device!"
> > > message continues forever.
> > 
> > Where is that loop exactly? Put CATCH in there.
> 
> That loop is in count-dos-logical-partitions. The reason why I didn't
> put a CATCH in there is because there is already another CATCH statement
> in do-load in slof/fs/boot.fs which covers this throw. For the other
> path that doesn't have a CATCH I have inserted a CATCH in the open
> subroutine in disk-label.fs.
> 
> > 
> > > SLOF doesn't have any option other than to use the block-size that was
> > > set in the logical_block_size parameter. It doesn't have any preference
> > > as the code is very generic for both DOS as well as GPT.
> > > > 
> > > > > Also change the "open" method to initiate CATCH exception handling for the calls to
> > > > > try-partitions/try-files which will also call read-sector which could potentially
> > > > > now throw this new exception.
> > > > > 
> > > > > After making the above changes, it fails properly with the correct error
> > > > > message as follows:
> > > > > <SNIP>
> > > > > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > virtioblk_transfer: Access beyond end of device!
> > > > > 
> > > > > E3404: Not a bootable device!
> > > > > 
> > > > > E3407: Load failed
> > > > > 
> > > > >   Type 'boot' and press return to continue booting the system.
> > > > >   Type 'reset-all' and press return to reboot the system.
> > > > > 
> > > > > Ready!
> > > > > 0 >
> > > > > </SNIP>
> > > > > 
> > > > > Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
> > > > > ---
> > > > > slof/fs/packages/disk-label.fs | 12 +++++++++---
> > > > > 1 file changed, 9 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> > > > > index 661c6b0..a6fb231 100644
> > > > > --- a/slof/fs/packages/disk-label.fs
> > > > > +++ b/slof/fs/packages/disk-label.fs
> > > > > @@ -136,7 +136,8 @@ CONSTANT /gpt-part-entry
> > > > > : read-sector ( sector-number -- )
> > > > >     \ block-size is 0x200 on disks, 0x800 on cdrom drives
> > > > >     block-size * 0 seek drop      \ seek to sector
> > > > > -   block block-size read drop    \ read sector
> > > > > +   block block-size read         \ read sector
> > > > > +   block-size < IF throw THEN    \ if we read less than the block-size then throw an exception
> > > > 
> > > > When it fails, is the number of bytes ever non zero? Thanks,
> > > No, it doesn't reach 0. It is lesser than the block-size. For example if
> > > we set the logcial_block_size to 1024, the block-size is that much. if
> > > we are reading the last sector which is physically only 512 bytes long
> > > then we read that 512 bytes which is lesser than 1024, which should be
> > > regarded as an error.
> > 
> > Ah so it only happens when there is an odd number of 512 sectors so reading the last one with block-size==1024 only reads a half => failure, is that right?
> 
> Yes. Or, block-size if set to 2048 or 4096 will also show the same problem.
> 
> > 
> > > > 
> > > > > ;
> > > > >  
> > > > > : (.part-entry) ( part-entry )
> > > > > @@ -723,10 +724,15 @@ CREATE GPT-LINUX-PARTITION 10 allot
> > > > >     THEN
> > > > >  
> > > > >     partition IF
> > > > > -       try-partitions
> > > > > +       ['] try-partitions
> > > > >     ELSE
> > > > > -       try-files
> > > > > +       ['] try-files
> > > > >     THEN
> > > > > +
> > > > > +   \ Catch any exception that might happen due to read-sector failing to read
> > > > > +   \ block-size number of bytes from any sector of the disk.
> > > > > +   CATCH IF false THEN
> > > Segher/Alexey, can we keep this CATCH block or should I remove it ?
> > 
> > imho the original bug should be handled more gracefully. Seeing exceptions in the code just triggers exceptions in my small brain :) Thanks,
> 
> :-). But this is the only other path that doesn't have a CATCH
> like the do-load subroutine in slof/fs/boot.fs. According to Segher
> there shouldn't ever be a problem with throw because if nothing else the
> outer-most interpreter loop's CATCH will catch the exception. But I
> thought to cover this throw in read-sector more locally in places near
> to this functionality. Because the outermost FORTH SLOF interpreter loop is not
> really so related to reading a sector in disk-label.fs.
> 
Alexey/Segher, so what should be the next steps ?
Do you find my explanation above okay or should I simply remove these
CATCH blocks ? Putting a CATCH block in count-dos-logical-partitions is
out of the question as there is already a CATCH in do-load in
slof/fs/boot.fs. This CATCH block in the open subroutine is actually to
prevent the exception to be caught at some non-local place in the code.

