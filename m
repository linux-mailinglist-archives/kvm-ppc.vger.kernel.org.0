Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C9A34F829
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhCaE5R (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhCaE4y (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 00:56:54 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C943C061574
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Mar 2021 21:56:53 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9DYv0L95z9sWK; Wed, 31 Mar 2021 15:56:50 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617166611; bh=19OgOaq+ZIMbNNJbMDGP6fgCyFoh4TXBEgpOg6Gntdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sW6QAytAhYBDzhZRB+xjJ3hkwA45lb45zqexsOLJuVZW3X+tXr6cy/VxO0vmc1ixs
         0qox4x1fRmH7Wp5G/yZZTeLK1cND/jboBMbvbijwgWbcKiXyKB4r6UiXn2aN1WuQYU
         6v8hsXXmFm1GX4mrFHu1+EAN4jRPkvJhH5md/tvZq8PkplTS6MFXfYDX1KdRxGLOAh
         v9gM6rH6RogyRcQ/Gmg3cM8tywFcqLP7cAVo1ZF9F13RUFhOLeAAfkFbHTcjDb2hAv
         1iRG3BFvJ3IPgEjVhm67qh8RTqKPWummxdGN/zM+uilB90v7db9lLd9BFYN+RWuQ2S
         qacEqKjBhHtGQ==
Date:   Wed, 31 Mar 2021 15:56:45 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>,
        Fabiano Rosas <farosas@linux.ibm.com>
Subject: Re: [PATCH v4 10/46] KVM: PPC: Book3S HV: Ensure MSR[ME] is always
 set in guest MSR
Message-ID: <YGQBDbDfFJuImaTg@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-11-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-11-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:29AM +1000, Nicholas Piggin wrote:
> Rather than add the ME bit to the MSR at guest entry, make it clear
> that the hypervisor does not allow the guest to clear the bit.
> 
> The ME set is kept in guest entry for now, but a future patch will
> warn if it's not present.
> 
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
