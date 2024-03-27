Return-Path: <kvm-ppc+bounces-79-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2E488D807
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 08:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90AA91C26060
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 Mar 2024 07:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595BB2E622;
	Wed, 27 Mar 2024 07:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EqJYE/+I"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3CB38DC7
	for <kvm-ppc@vger.kernel.org>; Wed, 27 Mar 2024 07:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711525762; cv=none; b=hkofslB2pdDwMRpkg8osCkIFmrgNyfmRqGcromHMGuqH3H5cxnhiQRHL+CjvXOAPPvE9WOGv7ESTmHlG2jThRN6xlxNuTZTEjWCwdA5QI+Zloc5RSJyfKIhBXfiKDWelBK9L8O5hPm8oi7JgBUUjqNtgTem33HhqoLKYV9270uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711525762; c=relaxed/simple;
	bh=J/Ry/BDRKGH4qiWWKPwSnsfZRnm+t/RQX7oHz+Vmixo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tfIl6WSjbhPAuk8r6FTC1+etutqiMP26VDfLQOwHFfC0GUwV7vSBIbUFQwLmqVqeje1+Ef0D2Qhx0juQTg/wsGBaCdtP1S+WjZoDx2FACBusXY8dedNfZ7w0zkMV/7APQyXsZ4IZU0Qynn/bnydWPB5ZYMNQ1vtrirMqgUAjnoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EqJYE/+I; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42R7dmOq013159;
	Wed, 27 Mar 2024 07:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=k1uE7YUROcNZUUDR7hPfudp4LIUYYRlhrQuxCWsKu9Y=;
 b=EqJYE/+I7gdorJjTPFFGoZclXOehEAFkTijpl31DWaEAQWhtZcCqWr6z8zIehVOwWf4d
 O3Vcy0/sjJW4jEgOI/53h4NDnLFiqmXo7deYwZDvUKF6IbW6oHRTmvf+7j+/5feBs9bF
 2C6OOjMCYjVdtZoXvFybSEPKQRxY/DMSufSToOcS/ucUj0HhffvPcra53+bqNgt0nirS
 tzT47nLSW0UMltOCG0lmg+pbclkSSH81o54KEADsH3+SEAAad5+4NVIlgQkyz7euhefg
 TCOswEDuaZo5L6a9SdOMaR3CZJAR95l7WXWD21MQ109ebPlqd6ZrWJRE1FV3lSGKDvf/ aA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x4f2vr196-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 07:49:12 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42R7nCEE029462;
	Wed, 27 Mar 2024 07:49:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3x4f2vr194-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 07:49:12 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42R6bX2e012965;
	Wed, 27 Mar 2024 07:49:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3x29t0neur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 Mar 2024 07:49:10 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42R7n7Ma24707618
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 27 Mar 2024 07:49:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 022E82004B;
	Wed, 27 Mar 2024 07:49:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E705820040;
	Wed, 27 Mar 2024 07:49:04 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.171.73.163])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 27 Mar 2024 07:49:04 +0000 (GMT)
Date: Wed, 27 Mar 2024 13:19:00 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>
Cc: aik@ozlabs.ru, slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v3] slof/fs/packages/disk-label.fs: improve checking for
 DOS boot partitions
Message-ID: <ZgPPbNJ1HkqqEzdF@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240327054127.633598-1-kconsul@linux.ibm.com>
 <1a2c81ce-e876-4684-a1f7-f68cfc5ccdae@redhat.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a2c81ce-e876-4684-a1f7-f68cfc5ccdae@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xyg0O_tyvxZ_Thp3ZjKoMHCzquDibkPz
X-Proofpoint-ORIG-GUID: wF2EmNWq8DEI3a3zWKxFSw8pfRMSXx5P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-27_04,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 clxscore=1015 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403270052

Hi Thomas/Alexey,

On 2024-03-27 08:45:36, Thomas Huth wrote:
> On 27/03/2024 06.41, Kautuk Consul wrote:
> > While testing with a qcow2 with a DOS boot partition it was found that
> > when we set the logical_block_size in the guest XML to >512 then the
> > boot would fail in the following interminable loop:
> > <SNIP>
> > Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > </SNIP>
> > 
> > Change the count-dos-logical-partitions Forth subroutine and the Forth
> > subroutines calling count-dos-logical-partitions to check for this access
> > beyond end of device error.
> > 
> > After making the above changes, it fails properly with the correct error
> > message as follows:
> > <SNIP>
> > Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > virtioblk_transfer: Access beyond end of device!
> > 
> > E3404: Not a bootable device!
> > 
> > E3407: Load failed
> > 
> >    Type 'boot' and press return to continue booting the system.
> >    Type 'reset-all' and press return to reboot the system.
> > 
> > Ready!
> > 0 >
> > </SNIP>
> > 
> > Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
> > ---
> >   slof/fs/packages/disk-label.fs | 16 ++++++++++++----
> >   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks, Thomas. Alexey, can you also review and possibly include this
patch in the next release ?

> 

