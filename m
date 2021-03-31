Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A4034F815
	for <lists+kvm-ppc@lfdr.de>; Wed, 31 Mar 2021 06:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbhCaEmQ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 31 Mar 2021 00:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbhCaEmA (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 31 Mar 2021 00:42:00 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA1AC061574
        for <kvm-ppc@vger.kernel.org>; Tue, 30 Mar 2021 21:42:00 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4F9DDk2zcQz9sWK; Wed, 31 Mar 2021 15:41:58 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1617165718; bh=xEB8YrXTrZzJClBwZlO/5KcuKVA0lD/HaU5zKt86Kjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tFwPa4OARDAAmZnSmwLW2jCSkLcEhYDB+V108h12dCOyKgREs3KqJjs1x8lpfZCFq
         cAqg5ppoIMCiE+OEQlZV6xWrQLJVr8Ig1FebFUhrpu3T0zMA1q81dqB396nngFUWDC
         Ug2igxMFuh2iYs1pBHcDicYthU/0so8VOjN/1Bdzp9hHz0Bubt8wVcNh+JxS82oulY
         2l8T+czu51rL9WbJZAuKWsn1wXxlaFMNrL0g+JgYBTkUIPmr8myZgsQU4jucyTtic0
         Ip0bGC8t0B+6GOIfYRYES09ygytz/Z7njsNXOnLv1n9sEeAPKtlYqzO099tjKokgfc
         9/1+TY/Jjth4A==
Date:   Wed, 31 Mar 2021 15:39:41 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH v4 07/46] KVM: PPC: Book3S HV: Fix
 CONFIG_SPAPR_TCE_IOMMU=n default hcalls
Message-ID: <YGP9DVWXeM2O1A18@thinks.paulus.ozlabs.org>
References: <20210323010305.1045293-1-npiggin@gmail.com>
 <20210323010305.1045293-8-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323010305.1045293-8-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, Mar 23, 2021 at 11:02:26AM +1000, Nicholas Piggin wrote:
> This config option causes the warning in init_default_hcalls to fire
> because the TCE handlers are in the default hcall list but not
> implemented.
> 
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
