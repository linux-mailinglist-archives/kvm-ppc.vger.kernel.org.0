Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA4B2DA61E
	for <lists+kvm-ppc@lfdr.de>; Tue, 15 Dec 2020 03:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgLOCQr (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 14 Dec 2020 21:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgLOCQb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 14 Dec 2020 21:16:31 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C191C0617A6;
        Mon, 14 Dec 2020 18:15:47 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Cw20x4l5jz9sS8; Tue, 15 Dec 2020 13:15:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1607998545; bh=ugDMLz0cIJY/0yg0ituBv2aXJJ7eai8cH4y0v0j0eN0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iGCM4a+7RiM9qj+CscAoWeiRykkq9SUrNAcnOlDbvTJpijcsRiBiClMIIvZ4Z0gpW
         rLlyGbj8APkhDBWSEqX0AxaF8aH4xRvPKJ7SvpbE1tVUNPo51senBpgwLW9yYRtR+E
         sWbJbhgUlDcn+fhe++QeMiFMQ9yxuCBOQGcHw9UtQw4x5lmLffGHGO6z2O2Wi5ZQ+4
         KGd/ilXRVxMACnZPa6txDg4rLcdP62pH0RYpd+8FdYXzZlItXAHy4A1KUUXVUcfcEg
         cQx/vmAx0vA6nREW5kfghPM63uxF8aAGOgZPQaJhKUDNxfEMCSfNlBzS6p7P3jyKgq
         2fpczAAPHPGBA==
Date:   Tue, 15 Dec 2020 13:14:57 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     xiakaixu1987@gmail.com
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] KVM: PPC: Book3S: Assign boolean values to a bool
 variable
Message-ID: <20201215021457.GB2441086@thinks.paulus.ozlabs.org>
References: <1604730382-5810-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604730382-5810-1-git-send-email-kaixuxia@tencent.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, Nov 07, 2020 at 02:26:22PM +0800, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the following coccinelle warnings:
> 
> ./arch/powerpc/kvm/book3s_xics.c:476:3-15: WARNING: Assignment of 0/1 to bool variable
> ./arch/powerpc/kvm/book3s_xics.c:504:3-15: WARNING: Assignment of 0/1 to bool variable
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
