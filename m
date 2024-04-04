Return-Path: <kvm-ppc+bounces-86-lists+kvm-ppc=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0A8897D2C
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Apr 2024 02:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DC5A51C216CC
	for <lists+kvm-ppc@lfdr.de>; Thu,  4 Apr 2024 00:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E741C37E;
	Thu,  4 Apr 2024 00:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b="cKjz5q5C";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LjGjsxGZ"
X-Original-To: kvm-ppc@vger.kernel.org
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645991078B
	for <kvm-ppc@vger.kernel.org>; Thu,  4 Apr 2024 00:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.111.4.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712191478; cv=none; b=iodMZb1E8KeBVtxiAUHFBJ6YYQkO5eJJmuuQWWr4ZcwSNZVVMGmBoeNLd4meYD8nDqxXvBl3SX/pzlcr+3QaWfjk88JQuepDkbJYfbjybRh1Qe1IpJdrHyjIUzMXCNGszFEJRSm75rwICETIKepwzicVUWzNETo2mB2vIInhQrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712191478; c=relaxed/simple;
	bh=2r0hudThjRUW8lgTubNzif6ypJODGyMBAgp0XjaSvjA=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=VrZ2wl2ry4tnBevq1vxdeNkwIKlqqwKqXKtZulKZmHTnj58QyeqJYScYXCRLIc55cYhLpIUgwVzHH1oUN2lnPjDd7c6lmLsR0Z61ogmJFYv/G9kzS1AGN9uBeqMflrM6eyz3WlnYnQmAT74d/HUK2fmICGT98aRT8sZUE8vjTvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru; spf=pass smtp.mailfrom=ozlabs.ru; dkim=pass (2048-bit key) header.d=ozlabs.ru header.i=@ozlabs.ru header.b=cKjz5q5C; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LjGjsxGZ; arc=none smtp.client-ip=66.111.4.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ozlabs.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ozlabs.ru
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailnew.nyi.internal (Postfix) with ESMTP id 552B85832E7;
	Wed,  3 Apr 2024 20:44:34 -0400 (EDT)
Received: from imap53 ([10.202.2.103])
  by compute1.internal (MEProxy); Wed, 03 Apr 2024 20:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.ru; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1712191474; x=1712195074; bh=6NuKVbz2bx
	OhWvZ/JuQqvINqRxrSovYwPdpN0XpY8As=; b=cKjz5q5CHL1wl+kdN9e3aVbht4
	IzH0/8VeMVAgyErTgxWlpwtRNi4977r/p/YKNRQvFED985FFfXtKVHkiP/aC4Ght
	HBuqhkRMtkph/IffaDFLvcQC6e8+oiD+trh7eVxLiJvUxAhe38BT8bchRiabp5Z4
	oVYH9SETbp31N1hYPd3kM1DUJiRboYYQf6SJiTnYVy3IcUk9PTOMb33/QKuf+1la
	3gsf4FjCT7sYqwvrRZWBPKN7Aa0XR1mlcpkkN1vgy9UKJs7VMnRBROQgDDoaVc3X
	yCN/JXNyrX8k4sUL+7TPhQH5epurUVW1TmfvP+g1wsYIXBi7LHodbMSzGRjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1712191474; x=1712195074; bh=6NuKVbz2bxOhWvZ/JuQqvINqRxrS
	ovYwPdpN0XpY8As=; b=LjGjsxGZRk9HaW4vz848bpW2bWIeooyQROBLsCw/rejL
	OPgHG4mrXW1N4jwYUw4OGPm9plV4VA1LTvnZmpZH2nLQf1Bcmf72OuLSdvvK88je
	0hPU1f8W2u34iYJEqQzd3I25GRW7k5qWj7SMLoaPKbVnzdus1LXpr2RGh57aWuJk
	mp0MRnB75b/KVq4Tx1OG7K3KtrK2YQW+6DzVEA2IkVh6np7kpAKDtsIO/2d7u2EB
	fkOA8e1OOniZdXiIEwJ82Tp+pkSFVFVdHPmj7ygoSS6dwctkVzwGV7bgILY1Mn3N
	QVBXFQXB4w8N4bO8X6SjXPEjz82FyfB9L6BIX0inDw==
X-ME-Sender: <xms:8fcNZu_GjOPfzQOaEKWJ9SIg78skeHxu_y1dDrtEu6ZyrSxFMhudBA>
    <xme:8fcNZuuJ9UvFFZLeKij_DFF4DZNXZR87K_RpbxvueRn1cuYwk8yaXPIVoVZJzeS7M
    Zb10Mus8rnPNo3MDAk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudefjedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehl
    vgigvgihucfmrghruggrshhhvghvshhkihihfdcuoegrihhksehoiihlrggsshdrrhhuqe
    enucggtffrrghtthgvrhhnpefhtdelkeeuteekueeffefhfeelueefvdffudfhvdfhhfdu
    veeikeegudeiteegteenucffohhmrghinhepohiilhgrsghsrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghikhesohiilhgrsghs
    rdhruh
X-ME-Proxy: <xmx:8fcNZkAzedd-RvoQmDe62kiBvqFFnHWm5wQg-MXdujgFftCg1yRYtA>
    <xmx:8fcNZme-iab-Lktvsy6qBFK-gz5KnILWSBcMyK0iuXdb3flruwNmhA>
    <xmx:8fcNZjNg7r7I-6BHgW5czPLyd5DN2zNUDO0PtVJ2DFWZjkPrzukt6A>
    <xmx:8fcNZglk19_j7Sp1pk51HkEtEUzE5iCiLcDJnulmqDEMKxTFibdIZA>
    <xmx:8fcNZlV4AV4wpsj6fq9SH9JaB2oldl5vVkyEGnid_5igwMvlni4GtQGv_aBf>
Feedback-ID: i6e394913:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id AE5F3364007B; Wed,  3 Apr 2024 20:44:33 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-333-gbfea15422e-fm-20240327.001-gbfea1542
Precedence: bulk
X-Mailing-List: kvm-ppc@vger.kernel.org
List-Id: <kvm-ppc.vger.kernel.org>
List-Subscribe: <mailto:kvm-ppc+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm-ppc+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <7f2ae3a7-fb41-4752-b9d3-353e90af1cb9@app.fastmail.com>
In-Reply-To: <645a1ae3-949a-4225-b6f6-81f782320a88@redhat.com>
References: <20240222061046.42572-1-kconsul@linux.vnet.ibm.com>
 <ZelgMYUM0CzMVjbE@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <ZffNo8fEywkKHQPA@li-a450e7cc-27df-11b2-a85c-b5a9ac31e8ef.ibm.com>
 <645a1ae3-949a-4225-b6f6-81f782320a88@redhat.com>
Date: Thu, 04 Apr 2024 11:44:13 +1100
From: "Alexey Kardashevskiy" <aik@ozlabs.ru>
To: "Thomas Huth" <thuth@redhat.com>,
 "Kautuk Consul" <kconsul@linux.vnet.ibm.com>
Cc: slof@lists.ozlabs.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH] slof/fs/packages/disk-label.fs: improve checking for DOS boot
 partitions
Content-Type: text/plain



On Mon, 18 Mar 2024, at 21:12, Thomas Huth wrote:

> Sorry, your original patch somehow didn't make it to my Inbox (though it's 
> visible on http://patchwork.ozlabs.org/project/slof/list/ so the problem is 
> certainly on my receiving side), so I just learnt about this patch today.

Not so sure, there are/were some oddities with it, see - patworks did not pick any response expect from Kautuk:

https://patchwork.ozlabs.org/project/slof/patch/20240202051548.877087-1-kconsul@linux.vnet.ibm.com/

Then I tweaked the mailman so may be it is fixed now. Thanks,

ps. I disagree about that "+COMP and -COMP" guy  as it is not making anything "more informative" as it is hardly ever possible with SLOF but it is a different story :)


