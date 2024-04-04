Return-Path: <kvm-ppc+bounces-85-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1EB6897D21
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Apr 2024 02:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53CFC28D954
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Apr 2024 00:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0AD02F2A;
	Thu,  4 Apr 2024 00:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b="l8xWZnGF";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ovZx3xIO"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0453729A0
	for <kvm-ppc@vger.kernel.org>; Thu,  4 Apr 2024 00:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.111.4.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712190973; cv=none; b=Iya9mPndVHDD2L8/fRRKXE6H27yKcWue0SZ7/IK/0H/u0uxbR/oy0Xob4MTEthN9lBzwCRHFPQO1Kpi0kyW9BiiD1Gi2pCjN0TN/jWkBzhMCsDR9SM4qXPnojNQANxnz2EHutMYcJMW8BCPS6nwuajAI6/vRY4qkPJuplnVUMOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712190973; c=relaxed/simple;
	bh=VP0hMLV+g5McbfmY21VlVOb+TqpvtSaWoQUVxmFkzIE=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=ipop1tfLwCz3vnAAUFO0PJf7/fH5Bw3gxmg9qktPqd7MIh6h6lal3Lha7TdkCObphLVnPQAxpWr/32+N4PQ5DuJLRRnqbl/es8ldLhY8hBXJnRIODG2K3ACIMETNktZS3k4JDGuDfrvDm46Gbfisl6tsT1i1zVDb+vWZM/4DKDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru; spf=pass smtp.mailfrom=ozlabs.ru; dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b=l8xWZnGF; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ovZx3xIO; arc=none smtp.client-ip=66.111.4.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.ru
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailnew.nyi.internal (Postfix) with ESMTP id 82E4C5832E7;
	Wed,  3 Apr 2024 20:36:04 -0400 (EDT)
Received: from imap53 ([10.202.2.103])
  by compute1.internal (MEProxy); Wed, 03 Apr 2024 20:36:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.ru; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1712190964; x=1712194564; bh=sHVRP4hDb6
	xgiK7NDjbt/RQbTbYEGV+AAgszp4h7Bzs=; b=l8xWZnGFIAGySUzDQntGp/k5aT
	iI5xGN8viOcRzL41YyfN6MWZv5xUf5ShPgEQAnN++1tjzBwMbGRJH7WLLmk3JPXJ
	Bt61gGHYEULpgfnmDiuZAZTKUNpNZSHv/5E7VUBZnuVfpQY0BdIjE8Q3X7vbKy9/
	CU8VNdl6Uw4a30Zq/Tq9uZ3mOpaJ1WDUTQsi/7RKIfmeY0QvYvpPST8gPqQH4wMI
	2eJsPQF0mi8U9luZrpgtzMEvAy6VLLPcjUcepC7iWWAqy0drBAwHS9Wa3OIjh0xA
	qjMJueDOFOuZAQmzWKFBlSYNDZd8dHmLTt9l+MIEmhsNe2RPSnQnzrjtCa0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1712190964; x=1712194564; bh=sHVRP4hDb6xgiK7NDjbt/RQbTbYE
	GV+AAgszp4h7Bzs=; b=ovZx3xIOF9a8Kf+Jt+BZdEEjIVcfyFdrgxrmNsehVCru
	lZq4W6WC9vKrMe1XWjKnO50csXhpnNL8AZlBWbyLu1+LLNV4da0nvXV2pSU3b3U0
	l2WtKPNbTp6vmMxoNM+R29bAgb8sZANJbXGvGMUtOuGfOk/JVWZXVYkoSbDmjM4M
	puAwNr+bKw1jaZqqk976VDPdkECvhRj5gBV9tM+xIPHKYLdYmwlS6bbrsMDalP/g
	4f4bdeIChcuA5ENz2g4KUls4fdoqplhxBV1Y5LnJkt7JD7LbigKnE3AjN9LIynnT
	bjMYAbokh8EgSa8u/zetAPYVkLXQGiCV2sZlL0LoFA==
X-ME-Sender: <xms:8_UNZvYsLD3XiI0UtIYDAcoSDbizEMnP_teukMy6BZC2BrH2FiVuPA>
    <xme:8_UNZuZE8sqe_mJU2GuuFRMf2fFpTQnmCU9VsWfSfJ1aAZmForuoxIAb09PGO63kr
    F3zkpXag-dv5shUkPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudefjedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehl
    vgigvgihucfmrghruggrshhhvghvshhkihihfdcuoegrihhksehoiihlrggsshdrrhhuqe
    enucggtffrrghtthgvrhhnpefggeevffffvdehgefhteetgedvieehudejfeduieeuvdeu
    vdevgfeufeefuedvvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrihhksehoiihlrggsshdrrhhu
X-ME-Proxy: <xmx:8_UNZh9SdgLofgHcyRyzwUFv307yzTJNqeOzfdZd_THt0pkrzW_cag>
    <xmx:8_UNZlo9oDUHIMo7Q9iuKWhZl2BP56gpHqrdLYwnRfNkNTmLVaKrtQ>
    <xmx:8_UNZqq_lKMImreSq4X55ekz6ztKa_irOQArm2cB6SYYYNuBWYvF1w>
    <xmx:8_UNZrTzJujCuiJUT2-PgJV8WMvsjGcCtD3qJX5X9yTW0u0ix6JpWw>
    <xmx:9PUNZvDZG0-DF24yYgD6UFk5capFQZ9WtqOAbqouonEoI-3k4B2mh251iRaV>
Feedback-ID: i6e394913:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 54621364007E; Wed,  3 Apr 2024 20:36:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-333-gbfea15422e-fm-20240327.001-gbfea1542
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
In-Reply-To: <20240328060009.650859-1-kconsul@linux.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
Date: Thu, 04 Apr 2024 11:35:43 +1100
From: "Alexey Kardashevskiy" <aik@ozlabs.ru>
To: "Kautuk Consul" <kconsul@linux.ibm.com>,
 "Segher Boessenkool" <segher@kernel.crashing.org>,
 "Thomas Huth" <thuth@redhat.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v4] slof/fs/packages/disk-label.fs: improve checking for DOS boot
 partitions
Content-Type: text/plain

First, sorry I am late into the discussion. Comments below.


On Thu, 28 Mar 2024, at 17:00, Kautuk Consul wrote:
> While testing with a qcow2 with a DOS boot partition it was found that
> when we set the logical_block_size in the guest XML to >512 then the
> boot would fail in the following interminable loop:

Why would anyone tweak this? And when you do, what happens inside the SLOF, does it keep using 512?

> <SNIP>
> Trying to load:  from: /pci@800000020000000/scsi@3 ...
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
> virtioblk_transfer: Access beyond end of device!
> </SNIP>
> 
> Change the "read-sector" Forth subroutine to throw an exception whenever
> it fails to read a full block-size length of sector from the disk.

Why not throwing an exception from the "beyond end" message point?
Or fail to open a device if SLOF does not like the block size? I forgot the internals :(

> Also change the "open" method to initiate CATCH exception handling for the calls to
> try-partitions/try-files which will also call read-sector which could potentially
> now throw this new exception.
> 
> After making the above changes, it fails properly with the correct error
> message as follows:
> <SNIP>
> Trying to load:  from: /pci@800000020000000/scsi@3 ...
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
> Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
> ---
> slof/fs/packages/disk-label.fs | 12 +++++++++---
> 1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> index 661c6b0..a6fb231 100644
> --- a/slof/fs/packages/disk-label.fs
> +++ b/slof/fs/packages/disk-label.fs
> @@ -136,7 +136,8 @@ CONSTANT /gpt-part-entry
> : read-sector ( sector-number -- )
>     \ block-size is 0x200 on disks, 0x800 on cdrom drives
>     block-size * 0 seek drop      \ seek to sector
> -   block block-size read drop    \ read sector
> +   block block-size read         \ read sector
> +   block-size < IF throw THEN    \ if we read less than the block-size then throw an exception

When it fails, is the number of bytes ever non zero? Thanks,

> ;
>  
> : (.part-entry) ( part-entry )
> @@ -723,10 +724,15 @@ CREATE GPT-LINUX-PARTITION 10 allot
>     THEN
>  
>     partition IF
> -       try-partitions
> +       ['] try-partitions
>     ELSE
> -       try-files
> +       ['] try-files
>     THEN
> +
> +   \ Catch any exception that might happen due to read-sector failing to read
> +   \ block-size number of bytes from any sector of the disk.
> +   CATCH IF false THEN
> +
>     dup 0= IF debug-disk-label? IF ." not found." cr THEN close THEN \ free memory again
> ;
>  
> -- 
> 2.31.1
> 
> 

