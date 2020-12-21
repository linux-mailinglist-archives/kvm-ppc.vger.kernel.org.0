Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 194402DFB4E
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Dec 2020 12:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgLULEN (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Dec 2020 06:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgLULEN (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Dec 2020 06:04:13 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFBDC061282;
        Mon, 21 Dec 2020 03:03:32 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4CzxR66P7qz9sW9; Mon, 21 Dec 2020 22:03:30 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Leonardo Bras <leobras.c@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20201208215707.31149-1-leobras.c@gmail.com>
References: <20201208215707.31149-1-leobras.c@gmail.com>
Subject: Re: [PATCH v2 1/1] powerpc/kvm: Fix mask size for emulated msgsndp
Message-Id: <160854857761.1696279.18011483882082447442.b4-ty@ellerman.id.au>
Date:   Mon, 21 Dec 2020 22:03:30 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 8 Dec 2020 18:57:08 -0300, Leonardo Bras wrote:
> According to ISAv3.1 and ISAv3.0b, the msgsndp is described to split RB in:
> msgtype <- (RB) 32:36
> payload <- (RB) 37:63
> t       <- (RB) 57:63
> 
> The current way of getting 'msgtype', and 't' is missing their MSB:
> msgtype: ((arg >> 27) & 0xf) : Gets (RB) 33:36, missing bit 32
> t:       (arg &= 0x3f)       : Gets (RB) 58:63, missing bit 57
> 
> [...]

Applied to powerpc/next.

[1/1] KVM: PPC: Book3S HV: Fix mask size for emulated msgsndp
      https://git.kernel.org/powerpc/c/87fb4978ef8f7e3d6f51ea8e259638c4e96f2fc0

cheers
