Return-Path: <kvm-ppc+bounces-98-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BEF98B1BAD
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Apr 2024 09:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C12F8282D41
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Apr 2024 07:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EBF67C53;
	Thu, 25 Apr 2024 07:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dM1B728Z"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F18B3C060
	for <kvm-ppc@vger.kernel.org>; Thu, 25 Apr 2024 07:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714029294; cv=none; b=eCIEUJiY6T/nTDxZTEN09b6Yc4UTauX9BxMbhAv36/JflMxFQSEZdgdJxON5TFUz+Xh7pVQqOUI1XAMlhdn/4P8lNUPCKy4/vZlG5UoHkAcgQpl0/EzTmJ7D/nBDp/mH2/TmZsWhhxKW+ds+UIl6Sd+rPOSFubwsiPaUJp/gzuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714029294; c=relaxed/simple;
	bh=eIq3HN2boZyGV/Hr6+9pgF1z7hT6Fj9j/MwrtedSIVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GetSQpEDeL0PFyGGg8PY0uW4llFz19YhZyKVYutuaaDIvDBRmuoLbnbUZoyhtSRsscFRR+QkdNXWwZQyU6DHsW2wOz5HJdrnRJJIuBuTRe/Ya6vU4TpHBjNRYaKE5a/kKvInM+MIFUGK277792UoAn1o2ssSnX/shMBfvRZeq6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dM1B728Z; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43P7DAV7011011;
	Thu, 25 Apr 2024 07:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=19+LymS6Johc83B9gWMDF+QbT1psCK/5JYVEIypMO3c=;
 b=dM1B728ZBEC0mM8SPqla7BFnOLgb84yqPB57/4OVGSw64yxVC3VYaqvUjHaLvjop6E46
 N+wVp5OXAENkCRK05Y8qlZ87bZY2a2aM30mSYFdYW+ilAtufJHqJKv1vFmk9/iU8GfXo
 f7RV3tNvUT5DQzfvTfLTst9YFmIS4+SXLi08nchiEfHedPbI6v5d0+38k89XYHahEOd6
 UgBtGhWLMKZRHwnthI4KsukapPv9Rhr/SS6Ve1ixjZ80nTvAnaFKGT8KfDBkKww16sMz
 iME4INOarMfpu4KqVetsIT0EQnHlS3ZFxNgAYbRLJaZm7fFVj667nA7wAZCEJM2Su/VA mw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqjk88050-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 07:14:44 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43P7EilX012994;
	Thu, 25 Apr 2024 07:14:44 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xqjk8804v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 07:14:44 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43P405dM020953;
	Thu, 25 Apr 2024 07:14:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xmre08k54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Apr 2024 07:14:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43P7EdOQ51380722
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Apr 2024 07:14:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8677F20043;
	Thu, 25 Apr 2024 07:14:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92BEB20040;
	Thu, 25 Apr 2024 07:14:38 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 25 Apr 2024 07:14:38 +0000 (GMT)
Date: Thu, 25 Apr 2024 12:44:36 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v4] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <ZioC3DqD7e45ScrK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
 <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: toHK8dr_3qyheZYzXYvg8xQV5qwAILv0
X-Proofpoint-GUID: brqzj-3s3OFEun6jlPAFkMHkFN68USxy
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_06,2024-04-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 impostorscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404250050

Hi,

On 2024-04-16 10:03:33, Kautuk Consul wrote:
> > 
> Alexey/Segher, so what should be the next steps ?
> Do you find my explanation above okay or should I simply remove these
> CATCH blocks ? Putting a CATCH block in count-dos-logical-partitions is
> out of the question as there is already a CATCH in do-load in
> slof/fs/boot.fs. This CATCH block in the open subroutine is actually to
> prevent the exception to be caught at some non-local place in the code.

Any ideas on how to proceed ?

> _______________________________________________
> SLOF mailing list
> SLOF@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/slof

