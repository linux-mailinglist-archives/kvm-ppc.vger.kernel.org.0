Return-Path: <kvm-ppc+bounces-117-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB3E8C4E61
	for <lists+kvm-ppc@lfdr.de>; Tue, 14 May 2024 11:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CF601C20916
	for <lists+kvm-ppc@lfdr.de>; Tue, 14 May 2024 09:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1233A1DFF0;
	Tue, 14 May 2024 09:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TZs150h3"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED10FFC1F
	for <kvm-ppc@vger.kernel.org>; Tue, 14 May 2024 09:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715677733; cv=none; b=UyT/IbYk9lfU7R80YndEIKuPngz6HpcWya3fjU/5D+QWoMoE16Lq07mcPzmabHoOPzxiFTcTLOqLwAv2hJyL0tfEIDwQAubrADoKK93dcY2vdDjSpq3tap5zUzb2/lO0Aba/5va2aKlsIGHdx620NTJsNkKBK+y3gqCkDHMnuP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715677733; c=relaxed/simple;
	bh=rBmGh7ZERTBVed30K2PDLmmLYicZc24kEtkaoHv4hsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DxtTxfSVzsRrxINj6/KcucJUo12fvUsJ+WZCI44glk091EIWB7+hQrW0429tG0uTYytVi+T3mOjAnVwuL1xDL2OsW9BiUNJK4nSnATbEMa44Ll8SCkWqLZnni9SUNeBff+J42rI7nU6LJaOvuj9mMnu1HTvsOxYjOg47Mt72GZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TZs150h3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44E8V4qx022008;
	Tue, 14 May 2024 09:08:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=bIOLIJKNFsWQqcF+f3Fqe0gpI5blez6tJxwrzFRZZ3w=;
 b=TZs150h3GBZyhZl2ORRiO7NKxAQvRxEppCmuM8pNkqborH2Qezj3z08sYIX096ZplT5+
 kbuLMDcXOfqNJXm+YQTyhlujWAGLVOpyR76dxEpHtH1k8gJK802p26LbbWJRG17fZUg4
 PL+4CVsYjONrGrEENchhXgO58wRKoOiskz/NMuRxGux8bCDyyiosZLnNkGGOmyFxYxIG
 mmk/oQnXmcML5mv26nW6MgTVkcf7+Mi5fcbGMLTdXA3vyNFwouCOLE8ck2cxU8d3FU+d
 as8m9h3Wm+gqChiN8co0WZXtzlHV/cIMXud7ChL0DTpf6cuCLIuNNjhBxSIBHoSSQQGm YA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y4439g59h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 09:08:42 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44E98g47024556;
	Tue, 14 May 2024 09:08:42 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3y4439g59c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 09:08:42 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44E60Sq4029603;
	Tue, 14 May 2024 09:08:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y2n7km7g0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 May 2024 09:08:41 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44E98bV021496254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 May 2024 09:08:39 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD5732004D;
	Tue, 14 May 2024 09:08:37 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D7D9120040;
	Tue, 14 May 2024 09:08:36 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 14 May 2024 09:08:36 +0000 (GMT)
Date: Tue, 14 May 2024 14:38:34 +0530
From: Kautuk Consul <kconsul@linux.ibm.com>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Thomas Huth <thuth@redhat.com>, slof@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: Re: [SLOF] [PATCH v4] slof/fs/packages/disk-label.fs: improve
 checking for DOS boot partitions
Message-ID: <ZkMqEvgG0HxpdVzs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
 <Zg+zbBi8orvaDzYf@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zh3/nZVuncUmcXq0@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZjS3qfuj+iopSZjR@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjS3qfuj+iopSZjR@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KOpGjNw8sSzSSxrsweMJHsXPVflz2agx
X-Proofpoint-GUID: G8twoOwypl9I7W_BLYjC4sqztme0CKbD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-14_03,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 malwarescore=0 mlxlogscore=792 bulkscore=0 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405140064

Hi Alexey/Segher,
> > :-). But this is the only other path that doesn't have a CATCH
> > like the do-load subroutine in slof/fs/boot.fs. According to Segher
> > there shouldn't ever be a problem with throw because if nothing else the
> > outer-most interpreter loop's CATCH will catch the exception. But I
> > thought to cover this throw in read-sector more locally in places near
> > to this functionality. Because the outermost FORTH SLOF interpreter loop is not
> > really so related to reading a sector in disk-label.fs.
> > 
> Alexey/Segher, so what should be the next steps ?
> Do you find my explanation above okay or should I simply remove these
> CATCH blocks ? Putting a CATCH block in count-dos-logical-partitions is
> out of the question as there is already a CATCH in do-load in
> slof/fs/boot.fs. This CATCH block in the open subroutine is actually to
> prevent the exception to be caught at some non-local place in the code.

Any ideas on how we proceed with this now ?

