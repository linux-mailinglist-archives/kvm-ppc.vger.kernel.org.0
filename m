Return-Path: <kvm-ppc+bounces-60-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BA24586696E
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 05:44:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 494DB1F210E2
	for <lists+kvm-ppc@lfdr.de>; Mon, 26 Feb 2024 04:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DAB199DC;
	Mon, 26 Feb 2024 04:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RzqBvuJN"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9264C91
	for <kvm-ppc@vger.kernel.org>; Mon, 26 Feb 2024 04:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708922652; cv=none; b=PjPqotCIxu+NgIqi/ppcI3iYRzYSc+adNl/K3OFi+if632E9WXZ4OvdptFJxANvDWOym8pWOQKdhGTtxe2Gg2p8sHz9Tg4kVYvU5z8do3pH+hYodaMuK/08u1/U/Xdu94v0z3zHu2j2ZGooFx/QRDNj/1nMEhmCVDkjUYNC+0k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708922652; c=relaxed/simple;
	bh=7l5sGqMR1qtttUdYsDW4YGdWsf35S3zZupNrOLKayrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O44+xRESn+zHmrMVS+9FaIv6xxuwZ+aOOY96c5C71aKpLFLpcX7W1JLd2NMFS3OjlgjPgAZNYk2nvO+AixohZyxESAv2p7itAPynxH7Wg8uG4ZtlhkZwHZqqpPZxXlxbGAzUWpXJmZuSeDTWcCrhRpl7POi+7AXEWCJAUrEMU/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RzqBvuJN; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q34pcN001412;
	Mon, 26 Feb 2024 04:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=rSiKn0Z9AtomHaMAngcGXwOEARs06z0oyD7Na/cvDDQ=;
 b=RzqBvuJNETXrc4rJVXBMm9p5MvzByH4qzgq6bEPa/p8UqMyFkUdrr5XggTm47z9YPEoC
 sShZObwbl6sIXwOCoRh0Q0dnwiMhNoZTw9lfRhD/p0fGyVK01kK8klxkr65lhJTNZCKt
 RJWfPT9Gj7080iBRdMPL20llgQNkr8YJLPQOdwlpI7qXhk4YttpJFSw2qZ6Bp4w1N19S
 KWkb2E0wKYhZJ9pA+/sfQKV2IiPNZbc/AsGuj8KCzHJe/rxKxwMSuw3DXITGz29G2dUo
 eNiqOFTlxvAhVbI8r8jQ3kKkGIcfUaa4EIeh2gOQy2Wsg5MPphKKHSd89z3lReEh08qW uQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wg7cjj8ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:43:57 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41Q4X7o5018034;
	Mon, 26 Feb 2024 04:43:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wg7cjj8du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:43:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41Q4Uq9d012338;
	Mon, 26 Feb 2024 04:43:55 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wfwg1x93b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Feb 2024 04:43:55 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41Q4hq234653712
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 04:43:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1AF242004E;
	Mon, 26 Feb 2024 04:43:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C2B3520049;
	Mon, 26 Feb 2024 04:43:50 +0000 (GMT)
Received: from li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com (unknown [9.109.216.99])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 Feb 2024 04:43:50 +0000 (GMT)
Date: Mon, 26 Feb 2024 10:13:48 +0530
From: Kautuk Consul <kconsul@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Thomas Huth <thuth@redhat.com>, aik@ozlabs.ru, groug@kaod.org,
        slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using
 COMPILE
Message-ID: <ZdwXBJNBMOr/SvaP@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zdb56vX+ZpApmsqK@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <278a0e1e-b257-47ef-a908-801b9a223080@redhat.com>
 <Zdc0CeOTVeob77Lj@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zdg0O/67vQIip7hN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223210456.GP19790@gate.crashing.org>
 <ZdwUc96KRsrKrd9c@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdwUc96KRsrKrd9c@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bw_h65BxQUFTMSW8n4byiPyOZMU-1Qv-
X-Proofpoint-GUID: X2i0kjVuSg9GDpjcNjBSfK0HfXoZ1kR5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_01,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=242 malwarescore=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402260033

Hi Thomas,

On 2024-02-26 10:02:55, Kautuk Consul wrote:
> On 2024-02-23 15:04:56, Segher Boessenkool wrote:
> > On Fri, Feb 23, 2024 at 11:29:23AM +0530, Kautuk Consul wrote:
> > > > > difference (e.g. by running the command in a tight loop many times)?
> > > Running a single loop many times will not expose much because that loop
> > > (which is NOT within a Forth colon subroutine) will compile only once.
> > > In my performance benchmarking with tb@ I have put 45 IF-THEN and
> > > IF2-THEN2 control statements that will each compile once and reveal the
> > > difference in compilation speeds.
> > 
> > All of this is only for things compiled in interpretation mode anyway.
> > Even how you get the source code in (read it from a slow flash rom in
> > the best case!) dominates performance.
> > 
> > You do not write things in Forth because it is perfect speed.  Write
> > things directly in machine code if you want that, or in another high-
> > level language that emphasises optimal execution speed.  The good things
> > about Forth are rapid prototyping, immediate testing of all code you
> > write, simple compact code, that kind of goodness.  Ideal for (system)
> > firmware!
> > 
> > 
> > Segher
> 
> Yes, but SLOF will be there on the product we sell to our customers.
> Considering that there is a noticeable improvement in performance I just
> thought maybe IBM management would be interested in it.

On this note, what did you also try to understand the performance
implications of my patch ? What improvements did you observer on your
set up?

