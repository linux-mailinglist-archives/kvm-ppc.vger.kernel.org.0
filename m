Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3392DA613
	for <lists+kvm-ppc@lfdr.de>; Tue, 15 Dec 2020 03:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgLOCQh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Dec 2020 21:16:37 -0500
Received: from ozlabs.org ([203.11.71.1]:49669 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgLOCQc (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Mon, 14 Dec 2020 21:16:32 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Cw20x5ZWFz9sRR; Tue, 15 Dec 2020 13:15:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1607998545; bh=HIoL3hYia/VL0H8kxL6qHX8RQtpD9XmN0+Gy2vsT9c0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a1eIbgUR8izZ8apPi6OAsVBqalg61msyq1wD1KLkArhkC7vAdmdAS17cb/B+XGiWp
         jnZ6skMXJvFPwVxQq2KWtYBYNCjp+ZdBVksqX/q+xu/6IcPTL+DGNa0lQK9QX9KpMd
         eHLkop+Fe+3aemWoK7rxsXDWTBAMk70i53x0QzNnkfPsj7+iE+QRjKRDLMk/zVLlWR
         dPrVU8f7K6tz7iljIYbmoKtqSGc8DVZPqx+kryU/lV8eI1m1OL9oAyasRL9N6ibJF3
         NjtCVm4ByCnE/nASHWNADKGa3k/ogFFdYirxOzRfsPCop290p0shx2iF0WTPCqkfn8
         FJNGj5C+s9XOw==
Date:   Tue, 15 Dec 2020 13:15:23 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Leonardo Bras <leobras.c@gmail.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] powerpc/kvm: Fix mask size for emulated msgsndp
Message-ID: <20201215021523.GC2441086@thinks.paulus.ozlabs.org>
References: <20201208215707.31149-1-leobras.c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208215707.31149-1-leobras.c@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Dec 08, 2020 at 06:57:08PM -0300, Leonardo Bras wrote:
> According to ISAv3.1 and ISAv3.0b, the msgsndp is described to split RB in:
> msgtype <- (RB) 32:36
> payload <- (RB) 37:63
> t       <- (RB) 57:63
> 
> The current way of getting 'msgtype', and 't' is missing their MSB:
> msgtype: ((arg >> 27) & 0xf) : Gets (RB) 33:36, missing bit 32
> t:       (arg &= 0x3f)       : Gets (RB) 58:63, missing bit 57
> 
> Fixes this by applying the correct mask.
> 
> Signed-off-by: Leonardo Bras <leobras.c@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
