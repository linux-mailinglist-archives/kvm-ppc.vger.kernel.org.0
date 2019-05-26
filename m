Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 295842AB1F
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 May 2019 18:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfEZQUw (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 26 May 2019 12:20:52 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39463 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfEZQUw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 26 May 2019 12:20:52 -0400
Received: by mail-lf1-f68.google.com with SMTP id f1so10349915lfl.6;
        Sun, 26 May 2019 09:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=01nMFHopGBCZI/oY5AFsKMqNsMt7+AjmjgP0ZjkgZD0=;
        b=H9kOov7CMbdB+pTxe0jciE/0X9oGCvFwZWDK1QndljD3nCAkXWhPqQrhRAkQi59WA+
         d1eMVPPgA648vZfajLaltDW4PpoUB4pt83MyTL8K46y+UiuRDyXY5HNuTOJif87Lqecv
         kL+pn979wtoM5zsiZjVxsKyorZ5fDMvXc5EYdLwfb29E7UMtLbbi6SY6+B9EjVK9V9N9
         jppYbzw6fnq8W4DKmTORjKAQGOTgjdVW0TITDNwUDfmzZIQ2GHdOG9eZLBAnZ2U1JIpK
         oZea98ME0YjW6/g1Ch8EirFC6vsAF2YeXFVxSa5XzAQMHPBzbwOOEGdLWTiIgXY9fDAt
         gF9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=01nMFHopGBCZI/oY5AFsKMqNsMt7+AjmjgP0ZjkgZD0=;
        b=d+AT28OZkvToROcSkbKH5jDUExZ2jL1zqXBWcbMzoaO5CnNKnVwB4Bdnv/W9KjTRCj
         LtlVH9zLz1zZpsECumMdLbQtQPydUVjZ1DJSGiiGjbqKCz316yY1s1DHHpGls2UBrZKr
         70XoB052Ee96vNxu3VhyGszjCIu9cHaG1T+l0kV831yzStmRS1azl4oaS7xwX9fesJNN
         kC4oWA5SZ98+J6gUY78k+Dz51z5EN01n2QMNAv2DinP0MhSyYnigXOH/kESj5qemSyVP
         OMNu3YFRAOLJx1txpji9nm1pU2hnV0lfrfprdNodnK0C/qEtUGW1r8vKtb2w83gi6h9R
         VL8Q==
X-Gm-Message-State: APjAAAWE8sW+PDz2rv9j219t4UDEqbUKp3r4ucW1/rFp753PEqoinbW2
        +HLac4dosE5i5QcANESRCNwOqGu5BeI41VXG1Pw=
X-Google-Smtp-Source: APXvYqwxMEk0IUeAy9UBTsg3h8S+c0X1iydUjhxKYRUIOzNVGYIXzMI1MwgnfY73XGd4ekjkgDqWVxxMzKH40Taah+c=
X-Received: by 2002:ac2:4213:: with SMTP id y19mr4505084lfh.66.1558887650127;
 Sun, 26 May 2019 09:20:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190524234933.5133-1-joel@joelfernandes.org> <20190524234933.5133-5-joel@joelfernandes.org>
In-Reply-To: <20190524234933.5133-5-joel@joelfernandes.org>
From:   Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sun, 26 May 2019 18:20:39 +0200
Message-ID: <CANiq72noLXGXo7iarC1vCYX3X5L4fXq1DASK9gMtD_25-VEuHA@mail.gmail.com>
Subject: Re: [PATCH RFC 4/5] rculist: Remove hlist_for_each_entry_rcu_notrace
 since no users
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, kvm-ppc@vger.kernel.org,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Sat, May 25, 2019 at 1:50 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> The series removes all users of the API and with this patch, the API
> itself.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  .clang-format           |  1 -

Ack for clang-format, and thanks for removing it there too! :-)

Cheers,
Miguel
