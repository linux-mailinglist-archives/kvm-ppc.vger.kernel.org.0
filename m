Return-Path: <kvm-ppc+bounces-90-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DECD58993F8
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Apr 2024 05:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94CE128CF41
	for <lists+kvm-ppc@lfdr.de>; Fri,  5 Apr 2024 03:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A26B12B93;
	Fri,  5 Apr 2024 03:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b="RPPs6bX6";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="nWnr8Urc"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from new2-smtp.messagingengine.com (new2-smtp.messagingengine.com [66.111.4.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F286A28E2
	for <kvm-ppc@vger.kernel.org>; Fri,  5 Apr 2024 03:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.111.4.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712288804; cv=none; b=BwF+YRN7JomR/p/LputZ+mZPaVxaD/wbTXeZsKRuUuUvEiKfG3SmdxTh4TGdaG2t/CbHoI48Es1LkrzcvX5AqReMhuuwQjjadYyIIRSoLuqC5vQby+cXibRGIVOYEMSxOSRU1lgFOLyCb/InGJtenOEi41aXt5k61vXZppuqrWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712288804; c=relaxed/simple;
	bh=l4o7XuI26lEwnvYWxLDs4ecvfIbYn4NMf8uXexFknXo=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=F8ZcjpaZsaFkg43gYXjKtNkfnpkdGn3fwautZD3qVkkkZjdqNHQ9OPs4mcSTmdHl6lNeHy18XYb7Ay/uW3q4FXHoUEkRx1U6VDcYEV/XzmekyrwnMtO7cDFHGH5KBuImH2Z6k4D0N28VkhR5/0ObTnt05SkXcZPOFJJDNhcsqYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru; spf=pass smtp.mailfrom=ozlabs.ru; dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b=RPPs6bX6; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=nWnr8Urc; arc=none smtp.client-ip=66.111.4.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.ru
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailnew.nyi.internal (Postfix) with ESMTP id 62ADE5809A7;
	Thu,  4 Apr 2024 23:46:37 -0400 (EDT)
Received: from imap53 ([10.202.2.103])
  by compute1.internal (MEProxy); Thu, 04 Apr 2024 23:46:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.ru; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1712288797; x=1712292397; bh=a4kb7X/MRH
	OKZuqu45bVvsd8ISq/Grb1ZY3MXE5M6zk=; b=RPPs6bX6yJAjvG8AXP7SwKx7GU
	Ju4QXUzFfqotSqDKfuWtVXgCxZJLP1owOsdBcCbe8CLUA1aNP5SrBpDvN3rFobS8
	yWEs/IzCYn9iDcWeQ/4pXxh7HRInxQJ2KCpuAoL6XPJRxd78zZZJ9P8bMP/X3GHA
	FxIEg0jRocJ4E359Z3wSsItSLLagZde1lbBryTnlKsJQR6iv6RA3BYDBNtGYnyhj
	PWwMQTRWglX6l9RQJ8H1tVOH6vvXkBfBU5jlIGPVp6Rfije2V0sV6/+T+I9on4Kz
	yFhupTFVs5vWM8/Lg8s2b5sWgjrw5Gz8VkZq4x/d6rgQkKu94CMeFxNMJCBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1712288797; x=1712292397; bh=a4kb7X/MRHOKZuqu45bVvsd8ISq/
	Grb1ZY3MXE5M6zk=; b=nWnr8UrcHfNRRvcwugizl2v/WAFlEblyx/JWkO97ZApi
	ZgqjzYXx+VvV5SkcFvIKkOJgddgSz3LBdgiy2fIcWNtu/+Ks7gH9WAwcoy6Eee4b
	tsh2zeYNFBksDsr/Vtg6j7D1SSTrinlAAwKqx+e+f7EEjLwXoIhhUE9WxCYRsrLF
	ECeTqJ282d7npfNVVgfbZhG0e5jOoYWUEQg3XvMnMPKK9hEqnIy4/YZMi+kHtuB8
	icQq8Smt4nwmxTxZ2igZVUcCFHgV887ptBIePKKdO/TR7HsdAbhVEdj3mtpVJIDF
	usnazMqXU5N3pEXJ3uEN4Y6Y9juVGL+SlGjC1IXx3Q==
X-ME-Sender: <xms:HHQPZj9s-dMJg9jdephxY8zRbbiAdIDkdnSTTbTSnCgYjSMjyeNzyQ>
    <xme:HHQPZvvMfQydKsqO3C_aVSwddIfL89PhbnyYstfFYtyBzfUys46OW6iZmeiwsNcau
    vhnoSvPlH3I8kI77Eo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudefledgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehl
    vgigvgihucfmrghruggrshhhvghvshhkihihfdcuoegrihhksehoiihlrggsshdrrhhuqe
    enucggtffrrghtthgvrhhnpefggeevffffvdehgefhteetgedvieehudejfeduieeuvdeu
    vdevgfeufeefuedvvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrihhksehoiihlrggsshdrrhhu
X-ME-Proxy: <xmx:HHQPZhAhfvCLMf_O1tAPIwSf0HnqnT2au-ESmeLxDj8X0-HkNP5pbA>
    <xmx:HHQPZvffC1dV5mSGMQ15QUQ3hKmDeIuh6rKoUjo0R7sp_pFSl7O-AA>
    <xmx:HHQPZoMKPqEGpRfjRshWGS-vUuFZwAd4m8UK18ba5XOFTORvPvCu1Q>
    <xmx:HHQPZhnIhjAwNH2zs_tUBXCFs30K9dpK9H0lYZqwEo0tpHdJhoekRQ>
    <xmx:HXQPZi1TrHtVwhImnpcd0isnySCFpNdoW8SbFij2Np2FsoPTVz-RdH6LrBuY>
Feedback-ID: i6e394913:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 82A333640074; Thu,  4 Apr 2024 23:46:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-333-gbfea15422e-fm-20240327.001-gbfea1542
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <e9496621-0fa5-4829-a01b-a382f80df516@app.fastmail.com>
In-Reply-To: 
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240328060009.650859-1-kconsul@linux.ibm.com>
 <c90f2e72-b9bc-419d-a279-58fcf6e3b644@app.fastmail.com>
 <Zg5UV2LEmRDPUWzo@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Date: Fri, 05 Apr 2024 14:46:14 +1100
From: "Alexey Kardashevskiy" <aik@ozlabs.ru>
To: "Kautuk Consul" <kconsul@linux.ibm.com>
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
 "Thomas Huth" <thuth@redhat.com>, slof@lists.ozlabs.org,
 kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v4] slof/fs/packages/disk-label.fs: improve checking for DOS boot
 partitions
Content-Type: text/plain



On Thu, 4 Apr 2024, at 18:18, Kautuk Consul wrote:
> On 2024-04-04 11:35:43, Alexey Kardashevskiy wrote:
> > First, sorry I am late into the discussion. Comments below.
> > 
> > 
> > On Thu, 28 Mar 2024, at 17:00, Kautuk Consul wrote:
> > > While testing with a qcow2 with a DOS boot partition it was found that
> > > when we set the logical_block_size in the guest XML to >512 then the
> > > boot would fail in the following interminable loop:
> > 
> > Why would anyone tweak this? And when you do, what happens inside the SLOF, does it keep using 512?
> Well, we had an image with DOS boot partition and we tested it with
> logical_block_size = 1024 and got this infinite loop.

This does not really answer to "why" ;)

> In SLOF the block-size becomes what we configure in the
> logical_block_size parameter. This same issue doesn't arise with GPT.

How is GPT different in this regard?

> > > <SNIP>
> > > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > </SNIP>
> > > 
> > > Change the "read-sector" Forth subroutine to throw an exception whenever
> > > it fails to read a full block-size length of sector from the disk.
> > 
> > Why not throwing an exception from the "beyond end" message point?
> > Or fail to open a device if SLOF does not like the block size? I forgot the internals :(
> This loop is interminable and this "Access beyond end of device!"
> message continues forever.

Where is that loop exactly? Put CATCH in there.

> SLOF doesn't have any option other than to use the block-size that was
> set in the logical_block_size parameter. It doesn't have any preference
> as the code is very generic for both DOS as well as GPT.
> > 
> > > Also change the "open" method to initiate CATCH exception handling for the calls to
> > > try-partitions/try-files which will also call read-sector which could potentially
> > > now throw this new exception.
> > > 
> > > After making the above changes, it fails properly with the correct error
> > > message as follows:
> > > <SNIP>
> > > Trying to load:  from: /pci@800000020000000/scsi@3 ...
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > virtioblk_transfer: Access beyond end of device!
> > > 
> > > E3404: Not a bootable device!
> > > 
> > > E3407: Load failed
> > > 
> > >   Type 'boot' and press return to continue booting the system.
> > >   Type 'reset-all' and press return to reboot the system.
> > > 
> > > Ready!
> > > 0 >
> > > </SNIP>
> > > 
> > > Signed-off-by: Kautuk Consul <kconsul@linux.ibm.com>
> > > ---
> > > slof/fs/packages/disk-label.fs | 12 +++++++++---
> > > 1 file changed, 9 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/slof/fs/packages/disk-label.fs b/slof/fs/packages/disk-label.fs
> > > index 661c6b0..a6fb231 100644
> > > --- a/slof/fs/packages/disk-label.fs
> > > +++ b/slof/fs/packages/disk-label.fs
> > > @@ -136,7 +136,8 @@ CONSTANT /gpt-part-entry
> > > : read-sector ( sector-number -- )
> > >     \ block-size is 0x200 on disks, 0x800 on cdrom drives
> > >     block-size * 0 seek drop      \ seek to sector
> > > -   block block-size read drop    \ read sector
> > > +   block block-size read         \ read sector
> > > +   block-size < IF throw THEN    \ if we read less than the block-size then throw an exception
> > 
> > When it fails, is the number of bytes ever non zero? Thanks,
> No, it doesn't reach 0. It is lesser than the block-size. For example if
> we set the logcial_block_size to 1024, the block-size is that much. if
> we are reading the last sector which is physically only 512 bytes long
> then we read that 512 bytes which is lesser than 1024, which should be
> regarded as an error.

Ah so it only happens when there is an odd number of 512 sectors so reading the last one with block-size==1024 only reads a half => failure, is that right?

> > 
> > > ;
> > >  
> > > : (.part-entry) ( part-entry )
> > > @@ -723,10 +724,15 @@ CREATE GPT-LINUX-PARTITION 10 allot
> > >     THEN
> > >  
> > >     partition IF
> > > -       try-partitions
> > > +       ['] try-partitions
> > >     ELSE
> > > -       try-files
> > > +       ['] try-files
> > >     THEN
> > > +
> > > +   \ Catch any exception that might happen due to read-sector failing to read
> > > +   \ block-size number of bytes from any sector of the disk.
> > > +   CATCH IF false THEN
> Segher/Alexey, can we keep this CATCH block or should I remove it ?

imho the original bug should be handled more gracefully. Seeing exceptions in the code just triggers exceptions in my small brain :) Thanks,

> > > +
> > >     dup 0= IF debug-disk-label? IF ." not found." cr THEN close THEN \ free memory again
> > > ;
> > >  
> > > -- 
> > > 2.31.1
> > > 
> > > 
> 

