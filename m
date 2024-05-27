Return-Path: <kvm-ppc+bounces-121-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BFD8D001B
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 May 2024 14:34:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4AB21C2093F
	for <lists+kvm-ppc@lfdr.de>; Mon, 27 May 2024 12:34:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAAD38FA6;
	Mon, 27 May 2024 12:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b="hzjDY5C7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Kfu69JWF"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from wfout5-smtp.messagingengine.com (wfout5-smtp.messagingengine.com [64.147.123.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EDB13B2A4
	for <kvm-ppc@vger.kernel.org>; Mon, 27 May 2024 12:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716813259; cv=none; b=ZIY7Sz2GXYE3Y8pkQpGNiq1c1cDEBavPMV9teQFfFcm87c7RfCLykLJDf/20F2EbbBM3uZ6r+gvQEIZ7Gl67l2gV01eu4gGu+azullGMToCUSEZuqHeM9VQykNe/Y2Tzz3RxJRozxGlzZG3m6wr4g/SIFex/xG5xMAtXL7fpLIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716813259; c=relaxed/simple;
	bh=VgIJHstx4Z+CA7culSLGgzhha3YLbCOuC0Oo7ss6jsU=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=j9Z3552DNDCXPL7MrzQSRYIcW4dIxoJdPAgiEioS0Gj2uHZMZnSXPdlyQa+yonYwzXoQ45fvBLG/0xZrNW/t+o7SR9AYQtfXDW1m8jzsNPtKOFmuMTeRayhEBtUdQDy85FLqKszFQX7QZVJs1KUSBtliOVficSEt+5P2PV/83BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru; spf=pass smtp.mailfrom=ozlabs.ru; dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b=hzjDY5C7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Kfu69JWF; arc=none smtp.client-ip=64.147.123.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.ru
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailfout.west.internal (Postfix) with ESMTP id 4F0881C000F8;
	Mon, 27 May 2024 08:34:11 -0400 (EDT)
Received: from imap53 ([10.202.2.103])
  by compute1.internal (MEProxy); Mon, 27 May 2024 08:34:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.ru; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1716813250; x=1716899650; bh=LFJcpto7ZV
	PEKX13k+PM6S44F6DOGxsFJHI4nh8hzGs=; b=hzjDY5C74jS5y3ZGiVq8pTar5v
	x+XToZBS7j0lPUj7aMzyNGBprXRuQWZJI4znNiUovTU3QcO6jUxW3zH+u0fpVru3
	XAq6eiS5GNjo2bFihdBsEI4T0Ii7pAfEu6j68ZStPTr4AIhqmkCrDVgpLUeG2e4y
	BGB+X8X72Z6nabWxL006SztICACbE5YXQJ8ooXG0WngUzJaJBF51s5L+askR2yOA
	nyQXH+0GDRx8KNgu6k1Ln0PMFDlMDZKJq9P048ZEbj3WMgAJq3lm8iuYndeetoId
	4qjKFAI+VfpZdAnRrx0UjH5Ydc3PXi8b452B4rfcA1x40kMBdHLSSH1GeIbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1716813250; x=1716899650; bh=LFJcpto7ZVPEKX13k+PM6S44F6DO
	GxsFJHI4nh8hzGs=; b=Kfu69JWF/Uubb6irfAsiWXIk3XUw3bnucPjThi7tD9ex
	FgWiTnYd3lTey4UquDnoy8a9DmKoHd/nYscCh6ENAUht9BYD0/Yvq/xWul84xZiY
	2BCghl/m7wTEZb+HmIycjzVxnDpQbfH8+KeS6BV83N/t11kQb4JZiFCUb0/oEo70
	/vd36vVGsT43E3DREh5OjbZWXbvqB06QJTBWwQ2DXyA7OiQ/g1zScXc5Mmal46lE
	wYfyNseGBKS3iAA2KEWA29F0Nob4aTYTjbEF43qwVrgvluQw5pUhZEYh1l6CcrCY
	A9efotPL31kNFMwPRPaI0/TKMj8ztgjQZ3JEj2/2Qg==
X-ME-Sender: <xms:wn1UZihNo6au8-cqkA6Zxs5e6vGOl2GVuDQln849oUdqTmc1rbHi8Q>
    <xme:wn1UZjDmr8N0AjaNeWLGDszegzcjeWOKUuDDzCE2r54mezKx111Tr6VK4Y65yvRjp
    hT3lY1-NGsJnPztImU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdejgedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehl
    vgigvgihucfmrghruggrshhhvghvshhkihihfdcuoegrihhksehoiihlrggsshdrrhhuqe
    enucggtffrrghtthgvrhhnpefggeevffffvdehgefhteetgedvieehudejfeduieeuvdeu
    vdevgfeufeefuedvvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegrihhksehoiihlrggsshdrrhhu
X-ME-Proxy: <xmx:wn1UZqF6VCYp5vi7z3ZCTpnYp5FtbCnfxz1O5XIDZzfZeUdHBunAGA>
    <xmx:wn1UZrRIdCek2vhqlfPQaw0Yhne6t83lvjymLf5OON8xgNmvEHoBvg>
    <xmx:wn1UZvxwCKD11N-vioh6R-YMzkyFhFBlNgJxNek9OfSxRazBLLhzOg>
    <xmx:wn1UZp4fUeo0TjaejWRYaZk2Pu9uR0g07e3Kg2kXRpwwJljaG_yyhw>
    <xmx:wn1UZmlNC42gLIhGpq5_n4Kz5dnvKiuFBbITNQwsBylJUtHovultjwsU>
Feedback-ID: i6e394913:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 094B73640070; Mon, 27 May 2024 08:34:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-491-g033e30d24-fm-20240520.001-g033e30d2
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <4fb7cb21-d8ea-4823-917b-7ce3f7349160@app.fastmail.com>
In-Reply-To: 
 <Zk21NmxuSUlWVhgs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
References: <20240202051548.877087-1-kconsul@linux.vnet.ibm.com>
 <Zcnkzks7D0eHVYZQ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <20240223205723.GO19790@gate.crashing.org>
 <ZdwV/1bmGSGi8MnZ@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZelfudAMYcXGCgBN@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZffNVdhtAzY32Jsx@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <Zk21NmxuSUlWVhgs@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
Date: Mon, 27 May 2024 22:33:49 +1000
From: "Alexey Kardashevskiy" <aik@ozlabs.ru>
To: "Kautuk Consul" <kconsul@linux.ibm.com>,
 "Kautuk Consul" <kconsul@linux.vnet.ibm.com>
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
 "Thomas Huth" <thuth@redhat.com>, "Greg Kurz" <groug@kaod.org>,
 slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH v2] slof/engine.in: refine +COMP and -COMP by not using COMPILE
Content-Type: text/plain



On Wed, 22 May 2024, at 19:04, Kautuk Consul wrote:
> Hi Segher/Alexey/Thomas,
> 
> > > > If you want to improve engine.in, get rid of it completely?  Make the
> > > > whol thing cross-compile perhaps.  Everything from source code.  The
> > > > engine.in thing is essentially an already compiled thing (but not
> > > > relocated yet, not fixed to some address), which is still in mostly
> > > > obvious 1-1 correspondence to it source code, which can be easily
> > > > "uncompiled" as well.  Like:
> > > 
> > > :-). Getting rid of it completely and making the whole thing
> > > cross-compile would require more time that I'm not so sure that I or
> > > even my manager would be able to spare in our project.
> > > 
> > > > 
> > > > col(+COMP STATE @ 1 STATE +! 0BRANCH(1) EXIT HERE THERE ! COMP-BUFFER DOTO HERE COMPILE DOCOL)
> > > > col(-COMP -1 STATE +! STATE @ 0BRANCH(1) EXIT COMPILE EXIT THERE @ DOTO HERE COMP-BUFFER EXECUTE)
> > > > 
> > > > : +comp  ( -- )
> > > >   state @  1 state +!  IF exit THEN
> > > >   here there !
> > > >   comp-buffer to here
> > > >   compile docol ;
> > > > : -comp ( -- )
> > > >   -1 state +!
> > > >   state @ IF exit THEN
> > > >   compile exit
> > > >   there @ to here
> > > >   comp-buffer execute ;
> > > > 
> > > > "['] semicolon compile," is not something a user would ever write.  A
> > > > user would write "compile exit".  It is standard Forth, it works
> > > > anywhere.  It is much more idiomatic..
> > > 
> > > Okay, I can accept the fact that maybe we should use EXIT instead of
> > > SEMICOLON. But at least can we remove the invocation of the "COMPILE"
> > > keyword in +COMP and -COMP ? The rest of the compiler in slof/engine.in
> > > uses the standard "DOTICK <word> COMPILE," format so why cannot we use
> > > this for -COMP as well as +COMP ?
> > > 
> Do you all agree with the above reasoning as well as the fact that I think
> we would all here (in the KVM team) appreciate even this small
> improvement in performance ?
> Can I send a v3 patch with the "DOTICK EXIT COMPILE," "DOTICK DOCOL COMPILE," changes ?
> 
> Or should I just abandon this patch ? My point is that when we aren't
> doing anything unorthodox in/with the slof/engine.in code then why not
> go in for a useful optimization in SLOF as this is part of the KVM Over
> PowerVM product ?

Is this optimization even measurable? :)

There is one thing which SLOF could do much faster (seconds or tens of seconds) - it is PCI scan where SLOF walks through all busses and slots even though it is all in the device tree already. But this "dotick" business does not scream for optimization imho. Thanks,

