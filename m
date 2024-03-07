Return-Path: <kvm-ppc+bounces-67-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 546AC87483B
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Mar 2024 07:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7C891F22701
	for <lists+kvm-ppc@lfdr.de>; Thu,  7 Mar 2024 06:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BF91BF2B;
	Thu,  7 Mar 2024 06:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iaBSBj38"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AECDD1848
	for <kvm-ppc@vger.kernel.org>; Thu,  7 Mar 2024 06:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709793349; cv=none; b=rnrfqJKCBM7+qJZ98PcMXieceXQsDIuia3YLG6JgvBKPQ6mItTOmTkAQvJpN21lrMCAjYtJnNpC+YwvSnpR//SxSXdlTj4Opgv3xiY38jDXCl1/1GNmCoaHTn/eRCtTTB4DMwDIhGHE/QpQJySQa18HxjQyxOXJU7V1yisVxbgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709793349; c=relaxed/simple;
	bh=moHqdHwE1LUyvFajAj72P15RSB8KnsVAOmyxZslItf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WwCLGkN2AkC/6vX7WtJ/8BNVYUWUoatFiFjTRfCrHOeG2N7RioEe+9OAoFA/Y+z5S0lG7TZs+f3gOGCixGPF8THSyEllNUg/GUv+VyYavf0CKgQ/NJgaTzv3iclQxW+NQEozjqDa9y0yxge2fGlSw8n4DxX13yMAuOCUF3ElWbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iaBSBj38; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4276WXuv007084;
	Thu, 7 Mar 2024 06:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=o96AZfC/axezVC0u1QdomPedLOT+vvaip1KRleIJydo=;
 b=iaBSBj38tTydWkf4AV6UiY0y/BkojPj2ap5vWI/VqJF3YZX+q+qzYT+RyNNxkxNe9cH0
 NTHTrg77ZZEhzZry81mQ2QXhaSqcFjwyh2DDH9JBWC30GSgWjYsAf/dGqkGXNWaDomRY
 9g3H6ZkWFfCg+UvBPohnltzQvhIWNrf0DJHNJcoqIEszK0EeZst4ZvpqGlQURPkRjzMk
 tvuV4rmZ64lbK+BnWOZuAQtqFo22rt7tU101GCJJNiyZXyNJ5LRwhKHiEdbEz8mKCcEG
 eWW0vLsrb1780bXoyVnyP1hDludBwbzWhjqSAeMx0bINe9UedHPzC8v7TScpPkMXw4Fo VA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wq8dd0256-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 06:35:41 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4276XauG009738;
	Thu, 7 Mar 2024 06:35:41 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wq8dd024q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 06:35:40 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42741fLT026212;
	Thu, 7 Mar 2024 06:35:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wmfep3tk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Mar 2024 06:35:40 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4276ZanE14025200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Mar 2024 06:35:38 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 21BF020040;
	Thu,  7 Mar 2024 06:35:36 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2434E2004B;
	Thu,  7 Mar 2024 06:35:35 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  7 Mar 2024 06:35:34 +0000 (GMT)
Date: Thu, 7 Mar 2024 12:05:29 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: aik@ozlabs.ru, Thomas Huth <thuth@redhat.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] slof/fs/packages/disk-label.fs: improve checking for DOS
 boot partitions
Message-ID: <ZelgMYUM0CzMVjbE@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240222061046.42572-1-kconsul@linux.vnet.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222061046.42572-1-kconsul@linux.vnet.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jsgCOX7f6dbXdBzV6aRVfjnEAkEUM487
X-Proofpoint-GUID: uefvGs4EkBFG1nVbPSVcfzcyVuakxib8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-07_02,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311290000 definitions=main-2403070046

Hi,

On 2024-02-22 01:10:46, Kautuk Consul wrote:
> While testing with a qcow2 with a DOS boot partition it was found that
> when we set the logical_block_size in the guest XML to >512 then the
> boot would fail in the following interminable loop:
> <SNIP>
> Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> </SNIP>
> 
> Change the count-dos-logical-partitions Forth subroutine and the Forth
> subroutines calling count-dos-logical-partitions to check for this access
> beyond end of device error.
> 
> After making the above changes, it fails properly with the correct error
> message as follows:
> <SNIP>
> Trying to load:  from: /pci@800000020000000/scsi@3 ... virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> virtioblk_transfer: Access beyond end of device!
> 
> E3404: Not a bootable device!
> 
> E3407: Load failed
> 
>   Type 'boot' and press return to continue booting the system.
>   Type 'reset-all' and press return to reboot the system.
> 
> Ready!
> 0 >
> </SNIP>
> 
> Signed-off-by: Kautuk Consul <kconsul@linux.vnet.ibm.com>
> ---
>  slof/fs/packages/disk-label.fs | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> index 661c6b0..e680847 100644
> --- a/slof/fs/packages/disk-label.fs
> +++ b/slof/fs/packages/disk-label.fs
> @@ -139,6 +139,13 @@ CONSTANT /gpt-part-entry
>     block block-size read drop    \ read sector
>  ;
> 
> +\ read sector to array "block" and return actual bytes read
> +: read-sector-ret ( sector-number -- actual)
> +   \ block-size is 0x200 on disks, 0x800 on cdrom drives
> +   block-size * 0 seek drop      \ seek to sector
> +   block block-size read    \ read sector
> +;
> +
>  : (.part-entry) ( part-entry )
>     cr ." part-entry>active:        " dup part-entry>active c@ .d
>     cr ." part-entry>start-head:    " dup part-entry>start-head c@ .d
> @@ -204,7 +211,8 @@ CONSTANT /gpt-part-entry
>           part-entry>sector-offset l@-le    ( current sector )
>           dup to part-start to lpart-start  ( current )
>           BEGIN
> -            part-start read-sector          \ read EBR
> +            part-start read-sector-ret          \ read EBR
> +            block-size < IF UNLOOP 0 EXIT THEN
>              1 partition>start-sector IF
>                 \ ." Logical Partition found at " part-start .d cr
>                 1+
> @@ -279,6 +287,7 @@ CONSTANT /gpt-part-entry
>     THEN
> 
>     count-dos-logical-partitions TO dos-logical-partitions
> +   dos-logical-partitions 0= IF false EXIT THEN
> 
>     debug-disk-label? IF
>        ." Found " dos-logical-partitions .d ." logical partitions" cr
> @@ -352,6 +361,7 @@ CONSTANT /gpt-part-entry
>     no-mbr? IF drop FALSE EXIT THEN  \ read MBR and check for DOS disk-label magic
> 
>     count-dos-logical-partitions TO dos-logical-partitions
> +   dos-logical-partitions 0= IF 0 EXIT THEN
> 
>     debug-disk-label? IF
>        ." Found " dos-logical-partitions .d ." logical partitions" cr
> -- 
> 2.31.1
> 

So how does the patch look ? Any comments ?

