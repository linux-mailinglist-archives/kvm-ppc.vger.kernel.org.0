Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A9ECD375
	for <lists+kvm-ppc@lfdr.de>; Sun,  6 Oct 2019 18:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbfJFQQZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 6 Oct 2019 12:16:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfJFQQY (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 6 Oct 2019 12:16:24 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7B70C85539
        for <kvm-ppc@vger.kernel.org>; Sun,  6 Oct 2019 16:16:24 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id z17so5803457wru.13
        for <kvm-ppc@vger.kernel.org>; Sun, 06 Oct 2019 09:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=Ne1NJ5apj4J7eKlGNACdxKeCUyhDUcktu7RQPHLTi2s=;
        b=YJM8ci7EgkBug3HvPxw/rTdCN7VY1EjaoQQBggGxscdEvYUDpoqtZOqjDZWcwubPiQ
         otRmtq2WKAkDL7s+58cFEfWuU+MLkuZhvAWUFoiTyfvsz9ccogtjtdaXy4wS0o34qrZL
         OUN2IByPDtiPnpod2ey2MF9cvXEmtSuEHkt/fz6w7lZlSDASJbGCuZ1cQweKvlLoc2mQ
         KSf+/3hdT5XM/j+I2XvzSSfOthpJcIq/Zo7vdUNe1STLB9tEsn13NQl9tBUw4gHMkEcH
         lHgfpHmwL8IwPgOVhgoXk2z+2565usqIL7E8F/9lg5956DG7yYytIR4inNIfbsgfu29V
         nebw==
X-Gm-Message-State: APjAAAWVeRMYZExkLG/KWGRg+I6kDFPRUrk8vTDKJlZQUOcEJQe74sO+
        UEyiWY+svrbGpl0SP3Y4jfRo0rUknpnDrq3SQ5QE64LjPp/0dieVf6WcN0VcTPaw/QT9CAjh32q
        5VwFp/tepcEhNyZUmAQ==
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr16923409wmg.177.1570378583123;
        Sun, 06 Oct 2019 09:16:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw7wvePKVU7og1wqb7GoCsGM1r5WqI/eu+qH+uH0thL7bVJo393LXZHuzcaf2milPUHaaaqrw==
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr16923397wmg.177.1570378582849;
        Sun, 06 Oct 2019 09:16:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e876:e214:dc8e:2846? ([2001:b07:6468:f312:e876:e214:dc8e:2846])
        by smtp.gmail.com with ESMTPSA id t8sm11111207wrx.76.2019.10.06.09.16.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Oct 2019 09:16:21 -0700 (PDT)
Subject: Re: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     lvivier@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, rkrcmar@redhat.com
References: <20191004103844.32590-1-david@gibson.dropbear.id.au>
 <a384c5e2-472a-32e5-2ee1-65c40da29840@redhat.com>
 <20191005081122.GB29310@umbus.fritz.box>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <22526d83-737f-c4aa-2fd5-84eb91b285d6@redhat.com>
Date:   Sun, 6 Oct 2019 18:16:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191005081122.GB29310@umbus.fritz.box>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RzIEYKulmZEWf9TATdnOFeZymPQtn8n0G"
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RzIEYKulmZEWf9TATdnOFeZymPQtn8n0G
Content-Type: multipart/mixed; boundary="dRNMGZyFagwZW3GezYwng5NqrIJ2ijKIT";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: lvivier@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org, rkrcmar@redhat.com
Message-ID: <22526d83-737f-c4aa-2fd5-84eb91b285d6@redhat.com>
Subject: Re: [PATCH] powerpc: Fix up RTAS invocation for new qemu versions
References: <20191004103844.32590-1-david@gibson.dropbear.id.au>
 <a384c5e2-472a-32e5-2ee1-65c40da29840@redhat.com>
 <20191005081122.GB29310@umbus.fritz.box>
In-Reply-To: <20191005081122.GB29310@umbus.fritz.box>

--dRNMGZyFagwZW3GezYwng5NqrIJ2ijKIT
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 05/10/19 10:11, David Gibson wrote:
> Fairly.  First, we'd have to not use -bios to replace the normal SLOF
> firmware - that could significantly slow down tests, since SLOF itself
> takes a little while to start up.

Oh, I forgot that PPC kvm-unit-tests use -bios.  That makes everything mo=
ot.

Paolo


--dRNMGZyFagwZW3GezYwng5NqrIJ2ijKIT--

--RzIEYKulmZEWf9TATdnOFeZymPQtn8n0G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2aE1gACgkQv/vSX3jH
roNzIwf/f8yhazxJUkYyq59AxfaY4mq6uI/lW3Ia+keEXOpjXEQwuKeQnTi/62YY
7Zdr1vBvH+eEAUClgKaIf8JwvzSTk82ZwTIHe9kUqtlfHM4XPWukKpRjPFuG8IJQ
hf2nGE6ALB1pkxppPz2ZM0Gb+ELixsKr0p/30Uiymox+/E//ndl4PPzQRbYpjZlQ
LesUr9cHJ3q8JYWtRSn0mApSc2FoyrtAk6vgAam/pcMMdDAUiNdIHObOyNLQ2Kp7
EoH2kJGTYVsfmXewd4vRDd0VzsjRazZOwJwEgSmLZijfME5wyRZqTQ0K8yGDGElN
yf140pGxkWr3W04qGfr6ZpTktsVVkA==
=Shs5
-----END PGP SIGNATURE-----

--RzIEYKulmZEWf9TATdnOFeZymPQtn8n0G--
