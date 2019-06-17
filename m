Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04538477BA
	for <lists+kvm-ppc@lfdr.de>; Mon, 17 Jun 2019 03:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbfFQBlS (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 16 Jun 2019 21:41:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54251 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727389AbfFQBlS (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 16 Jun 2019 21:41:18 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45Rv7b6cCgz9sDB; Mon, 17 Jun 2019 11:41:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1560735675; bh=WdFBYNUSs+HivApUCyKXEJHS4DzLzar43O+1K6I8HsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hAK5bZCzc0ZYM/1gLrvv3N+l+sZbYMBlSMDfa2wzyMN3gSu4jedxQcOOhVmjnk0N6
         mRb090bkWJxsVcMnmKrfbLb8VJBPJb7fKa4zaQURmYbtCbCLYQuLbvsQG1KHu3L9Vw
         dCTl4G7MQjxRVbnOgbWLmcS+HP5s2cC7bTFVOc+EgpAx4s3lMJxYSoG33Xqzi4Px4z
         2MrTe/4zXzS72XrF33N+5fMAOsMh8pFQg8bjkaeHrYWhRpzrBSY6fICB46wTPgIpVl
         IpdhgdrKqQ+xqFZTQrpIza193nFxdSuQqWwSPbAVo9q9z9tf2YwqBAdX63yoFS3raU
         HQMCUO8LDOigA==
Date:   Mon, 17 Jun 2019 11:41:12 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 3/5] KVM: PPC: Book3S HV: Reuse kvmppc_inject_interrupt
 for async guest delivery
Message-ID: <20190617014112.n2mvrk3jx2htmuqr@oak.ozlabs.ibm.com>
References: <20190520005659.18628-1-npiggin@gmail.com>
 <20190520005659.18628-3-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520005659.18628-3-npiggin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, May 20, 2019 at 10:56:57AM +1000, Nicholas Piggin wrote:
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

This really needs a couple of paragraphs describing what's going on
here, and why...

Paul.
