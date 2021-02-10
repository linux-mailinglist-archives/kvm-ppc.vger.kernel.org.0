Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338C7315C4A
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Feb 2021 02:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234386AbhBJBbR (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Feb 2021 20:31:17 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:56935 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234568AbhBJB3j (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Tue, 9 Feb 2021 20:29:39 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Db2Gd4pBGz9sVJ; Wed, 10 Feb 2021 12:28:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1612920537; bh=BnOJb4ZECVpQ0/TDZLWFgS+PJkwVFMihslRyuD73OY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jmtx5CCELjX9ivmdhCV6xHy1KOsfFoVuol8Std0nWY4Q+EbqOS3AWf/lPU7osn5Et
         5iyGTrVI7hRGzIlEc1YNdwn/K39dDy/BqkmS/Iss6zlWCK7eJUKTyg7CLmphq/ci+q
         JGJ/Pwy0cf3too90aD0A0TeiR6mWL5XhezPCPwnRcKtyI/AkYdv7h7r23J+AMJW7sa
         MEPTzpHZV9whA1txzax1Md0PgiBOkyWciTOkcN5+OspQvnpCa3isiejs+BFHpIb1GA
         /SpLZiEIx09QQ2RjvcC22IRBAmudiJw8K/A1rqk97yFv3ZAR+tEcshmiO8MXVjt6NR
         WTXyuDZnLhxmw==
Date:   Wed, 10 Feb 2021 12:28:52 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] KVM: PPC: Book3S HV: Fix radix guest SLB side channel
Message-ID: <20210210012852.GD2854001@thinks.paulus.ozlabs.org>
References: <20210118062809.1430920-1-npiggin@gmail.com>
 <20210118062809.1430920-3-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118062809.1430920-3-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, Jan 18, 2021 at 04:28:07PM +1000, Nicholas Piggin wrote:
> The slbmte instruction is legal in radix mode, including radix guest
> mode. This means radix guests can load the SLB with arbitrary data.
> 
> KVM host does not clear the SLB when exiting a guest if it was a
> radix guest, which would allow a rogue radix guest to use the SLB as
> a side channel to communicate with other guests.

No, because the code currently clears the SLB when entering a radix
guest, which you remove in the next patch.  I'm OK with moving the SLB
clearing from guest entry to guest exit, I guess, but I don't see that
you are in fact fixing anything by doing so.

Paul.
